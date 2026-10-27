@abstract
extends ItemComponent
class_name AttackItemComponent


## 0 = infinite ammo.
@export var magazine_size := 0


@abstract func _fire(ctx: ItemComponentContext, action: ActionContext) -> void


func perform(ctx: ItemComponentContext) -> void:
	if not _consume_ammo(ctx): return
	var action := ActionContext.new(ctx)
	_fire(ctx, action)
	apply_action_effects(action)


func _consume_ammo(ctx: ItemComponentContext) -> bool:
	if magazine_size <= 0: return true
	var ammo: int = ctx.stack.state.get("ammo", magazine_size)
	if ammo <= 0: return false
	ctx.stack.state["ammo"] = ammo - 1
	return true
