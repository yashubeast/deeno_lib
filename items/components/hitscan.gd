extends AttackItemComponent
class_name HitscanItemComponent


@export var max_range := 100.0
@export_flags_3d_physics var hit_mask := 0xFFFFFFFF


func _fire(ctx: ItemComponentContext, action: ActionContext) -> void:
	var dir := ctx.get_direction()
	var from := ctx.aim.global_position
	var to := from + dir * max_range
	var exclude: Array[RID] = [(ctx.host as CollisionObject3D).get_rid()]
	var query := PhysicsRayQueryParameters3D.create(from, to, hit_mask, exclude)
	var result := ctx.aim.get_world_3d().direct_space_state.intersect_ray(query)

	action.has_end = true
	action.end = to if result.is_empty() else result.position as Vector3

	if result.is_empty(): return
	apply_hit_effects(HitContext.from_ray(ctx.host, result, dir))
