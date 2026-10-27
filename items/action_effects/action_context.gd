extends RefCounted
class_name ActionContext
## Info about a action at the moment it is triggered.


var ctx: ItemComponentContext
## Usually for hitscan attacks.
var has_end := false
var end: Vector3


func _init(p_ctx: ItemComponentContext) -> void:
	ctx = p_ctx
