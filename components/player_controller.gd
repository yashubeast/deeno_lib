extends Component
class_name PlayerControllerComponent
## Reads InputComponent.
## Converts that input into either direct actions
## or into intent and passes those intents to other components(example: VelocityComponent).
## Also applies mouse look to the yaw/pitch pivots.


@export var yaw_pivot: Node3D
@export var pitch_pivot: Node3D
@export_group("camera zoom")
@export var _zoom_enabled := false
@export_subgroup("shoulder_mode")
@export var _shoulder_enabled := false
@export var _shoulder_offset := 0.6
@export_subgroup("")
@export var camera: Camera3D
@export var min_zoom := 0.0
@export var min_third_person_zoom := 2.0
@export var max_zoom := 4.0
@export var zoom_step := 0.5
@export var zoom_smoothing := 12.0
var _camera_base_x := 0.0
var _zoom_target := 0.0
var _zoom_current := 0.0
var _shoulder_current := 0.0
var mouse_sensitivity := 0.003
var pitch_limit_deg   := 90.0
var _input: InputComponent
var _velocity: VelocityComponent


func _accepts(h: Node) -> bool:
	if h is not CharacterBody3D: return false
	return manager.has_components([InputComponent, VelocityComponent])


func _component_ready()-> void:
	_input    = manager.get_component(InputComponent) as InputComponent
	_velocity = manager.get_component(VelocityComponent) as VelocityComponent
	if _zoom_enabled and camera:
		_zoom_target = clampf(camera.position.z, min_zoom, max_zoom)
		if _zoom_target < min_third_person_zoom: _zoom_target = min_zoom
		_zoom_current = _zoom_target
		_camera_base_x = camera.position.x
		_shoulder_current = _get_shoulder_target()


# Look runs every rendered frame so the camera feels smooth.
func _process(delta: float) -> void:
	if _zoom_enabled: _update_zoom(delta)

	var look := _input.consume_look()
	if look == Vector2.ZERO: return
	yaw_pivot.rotate_y(-look.x * mouse_sensitivity)
	pitch_pivot.rotate_x(-look.y * mouse_sensitivity)
	var limit := deg_to_rad(pitch_limit_deg)
	pitch_pivot.rotation.x = clampf(pitch_pivot.rotation.x, -limit, limit)


func _physics_process(delta: float) -> void:
	var move := _input.get_move()
	var moving := move.length() > 0.1

	# Move relative to where the head is facing.
	var yaw_basis := yaw_pivot.global_basis
	_velocity.wish_dir = (yaw_basis * Vector3(move.x, 0.0, move.y)).normalized()
	_velocity.wish_speed = _velocity.sprint_speed if (_input.is_sprint_held() and moving) \
			else _velocity.walk_speed
	_velocity.wants_jump = _input.is_jump_held()

	_velocity.tick(delta)


func _update_zoom(delta: float) -> void:
	if camera == null: return

	# Scroll up = zoom in (towards first person), scroll down = zoom out.
	var scroll := _input.consume_scroll()
	if scroll != 0.0:
		var new_target := _zoom_target - scroll * zoom_step

		if _zoom_target <= min_zoom:
			# In first person: scrolling out jumps straight to third person.
			if scroll < 0.0: new_target = min_third_person_zoom
		elif new_target < min_third_person_zoom:
			# In third person: scrolling in past the minimum goes straight to first person.
			new_target = min_zoom

		_zoom_target = clampf(new_target, min_zoom, max_zoom)

	# Frame rate independent smoothing.
	_zoom_current = lerpf(_zoom_current, _zoom_target, 1.0 - exp(-zoom_smoothing * delta))
	camera.position.z = _zoom_current

	# Shoulder.
	_shoulder_current = lerpf(_shoulder_current, _get_shoulder_target(), 1.0 - exp(-zoom_smoothing * delta))
	camera.position.x = _camera_base_x + _shoulder_current


func _get_shoulder_target() -> float:
	# No offset in first person.
	if not _shoulder_enabled or _zoom_target <= min_zoom: return 0.0
	return _shoulder_offset
