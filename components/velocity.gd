extends Component
class_name VelocityComponent
## Turns movement intent into actual CharacterBody3D motion
## (friction, air control, gravity, jumping).
## Regardless of who sets the intent: PlayerController, AI controller or whatever.
## A controller sets the intent fields and then calls tick() once per physics frame.


@export var walk_speed        := 5.0
@export var sprint_speed      := 6.5
@export var jump_velocity     := 8.0
@export var terminal_velocity := 80.0
@export var ground_friction   := 12.0
@export var air_accel         := 8.0
@export var air_drag          := 2.0
@export var gravity           := 28.0
# Intent (set by a controller before tick() call
## 2D direction, length 0..1.
var wish_dir   := Vector3.ZERO
## Target speed on the ground.
var wish_speed := 0.0
## Set true to jump this frame (only works on the floor).
var wants_jump := false
var _body: CharacterBody3D


func _accepts(h: Node) -> bool:
	return h is CharacterBody3D


func _component_ready() -> void:
	_body = host as CharacterBody3D


## Call once per physics frame, after the intent has been set.
func tick(delta: float) -> void:
	var vel := _body.velocity
	var horizontal := Vector2(vel.x, vel.z)
	var wish := Vector2(wish_dir.x, wish_dir.z)

	if _body.is_on_floor():
		# Ease towards the target velocity.
		horizontal = horizontal.lerp(wish * wish_speed, 1.0 - exp(-ground_friction * delta))
		if wants_jump:
			vel.y = jump_velocity
			wants_jump = false
	else:
		# Weak steering plus drag, and gravity.
		horizontal += wish * air_accel * delta
		horizontal *= exp(-air_drag * delta)
		vel.y = maxf(vel.y - gravity * delta, -terminal_velocity)

	vel.x = horizontal.x
	vel.z = horizontal.y
	_body.velocity = vel
	_body.move_and_slide()


func is_on_floor() -> bool:
	return _body.is_on_floor()
