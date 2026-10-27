@abstract
extends Resource
class_name ItemComponent


@export var input: StringName = &"lmb"
@export var cooldown := 0.15
@export var automatic := false
@export var action_effects: Array[ActionEffect] = []
@export var hit_effects: Array[HitEffect] = []


func try_use(ctx: ItemComponentContext, just_pressed: bool, held_down: bool) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	if now < float(ctx.stack.ready_at.get(self, 0.0)): return
	ctx.stack.ready_at[self] = now + cooldown
	perform(ctx)


@abstract func perform(ctx: ItemComponentContext) -> void


func apply_action_effects(action: ActionContext) -> void:
	for e in action_effects: e.apply(action)


func apply_hit_effects(hit: HitContext) -> void:
	for e in hit_effects: e.apply(hit)
