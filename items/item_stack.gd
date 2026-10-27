extends Resource
class_name ItemStack


@export var item: Item
@export var count := 1
## Runtime only. ItemComponent -> time (seconds) when it can fire again.
var ready_at := {}
## Runtime only. Ammo, durability, anything per-stack.
var state := {}


func _init(p_item: Item = null, p_count: int = 1) -> void:
	item = p_item
	count = p_count
