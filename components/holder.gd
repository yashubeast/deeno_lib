extends Component
class_name HolderComponent


@export var hand: Node3D
@export var aim: Node3D
var stack: ItemStack
var _model: Node3D


func _component_ready() -> void:
	var inv := manager.get_component(InventoryComponent) as InventoryComponent
	if inv == null: return
	inv.selected_item_stack_changed.connect(func(_i: int) -> void: equip(inv.get_selected()))
	inv.slot_changed.connect(func(_i: int) -> void: equip(inv.get_selected()))
	equip(inv.get_selected())


func equip(new_stack: ItemStack) -> void:
	var old_item: Item = stack.item if stack else null
	var new_item: Item = new_stack.item if new_stack else null
	stack = new_stack
	if new_item == old_item: return # same item, don't rebuild the model
	if is_instance_valid(_model): _model.queue_free()
	_model = null
	if new_item and new_item.held_scene:
		_model = new_item.held_scene.instantiate() as Node3D
		hand.add_child(_model)


func use(input: StringName, just_pressed: bool, held_down: bool) -> void:
	if stack == null or stack.item == null: return
	var ctx := ItemComponentContext.new()
	ctx.holder = self
	ctx.stack = stack
	ctx.aim = aim
	ctx.muzzle = _model.get_node_or_null("%Muzzle") as Node3D if _model else null
	for a in stack.item.components: if a.input == input: a.try_use(ctx, just_pressed, held_down)
