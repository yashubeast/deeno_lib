extends ActionEffect
class_name TracerActionEffect


@export var color := Color(1.0, 0.85, 0.4)
@export var width := 0.02
@export var lifetime := 0.06


func apply(action: ActionContext) -> void:
	if not action.has_end: return
	Tracer.spawn(action.ctx.aim, action.ctx.get_origin(), action.end, color, width, lifetime)
