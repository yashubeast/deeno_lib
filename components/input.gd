extends Component
class_name InputComponent
## Reads raw player input and exposes it as plain values.
## Input from this component is supposed to be consumed by ControllerComponent(s).
## Example: PlayerControllerComponent.


var capture_mouse_on_ready := true
## Mouse motion collected since the last consume_look() call.
var _look_delta := Vector2.ZERO
## Scroll collected since the last consume_scroll() call.
var _scroll_delta := 0.0


func _component_ready() -> void:
	if capture_mouse_on_ready:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	# Collect mouse motion. The controller consumes it every rendered frame.
	if event is InputEventMouseMotion and is_mouse_captured():
		_look_delta += event.relative

	# Collect scroll wheel.
	if event is InputEventMouseButton and event.pressed and is_mouse_captured():
		var amount: float = event.factor if event.factor > 0.0 else 1.0
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: _scroll_delta += amount
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN: _scroll_delta -= amount

	# Free mouse.
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Recapture mouse.
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not is_mouse_captured():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func is_mouse_captured() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func get_move() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func is_jump_held() -> bool:
	return Input.is_action_pressed("ui_accept")


func is_sprint_held() -> bool:
	return Input.is_action_pressed("sprint")


## Returns accumulated mouse motion and resets it.
func consume_look() -> Vector2:
	var d := _look_delta
	_look_delta = Vector2.ZERO
	return d


## Returns accumulated scroll and resets it.
func consume_scroll() -> float:
	var d := _scroll_delta
	_scroll_delta = 0.0
	return d


func is_lmb_held() -> bool:
	return is_mouse_captured() and Input.is_action_pressed("lmb")


func is_lmb_just_pressed() -> bool:
	return is_mouse_captured() and Input.is_action_just_pressed("lmb")
