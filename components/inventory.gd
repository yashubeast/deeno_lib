extends Component
class_name InventoryComponent

signal slot_changed(index: int)
signal selected_item_stack_changed(index: int)

@export var size := 9
@export var starting_items: Array[ItemStack] = []
var slots: Array[ItemStack] = []
var selected := 0


func _ready() -> void:
	# Sized in _ready (not _component_ready) so sibling order doesn't matter.
	slots.resize(size)


func _component_ready() -> void:
	for s in starting_items:
		if s != null and s.item != null: add_item(s.item, s.count)


## Returns the leftovers that didn't fit.
func add_item(item: Item, count := 1) -> int:
	for i in slots.size():
		var s := slots[i]
		if s == null or s.item != item: continue
		var moved := mini(item.max_stack - s.count, count)
		if moved <= 0: continue
		s.count += moved
		count -= moved
		slot_changed.emit(i)
		if count == 0: return 0
	for i in slots.size():
		if slots[i] != null: continue
		var moved := mini(item.max_stack, count)
		slots[i] = ItemStack.new(item, moved)
		count -= moved
		slot_changed.emit(i)
		if count == 0: return 0
	return count


func select(index: int) -> void:
	index = clampi(index, 0, slots.size() - 1)
	if index == selected: return
	selected = index
	selected_item_stack_changed.emit(selected)


func get_selected() -> ItemStack:
	return slots[selected] if selected < slots.size() else null
