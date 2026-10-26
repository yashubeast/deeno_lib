extends Component
class_name PlayerControllerComponent
## Reads InputComponent.
## Converts that input into either direct actions
## or into intent and passes those intents to other components(example: VelocityComponent).
## Also applies mouse look to the yaw/pitch pivots.


@export var yaw_pivot: Node3D
@export var pitch_pivot: Node3D
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


# Look runs every rendered frame so the camera feels smooth.
func _process(_delta: float) -> void:
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
