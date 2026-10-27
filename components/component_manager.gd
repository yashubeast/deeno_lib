extends Node
class_name ComponentManager


var host: Node
var components: Array[Component] = []


func _ready() -> void:
	host = get_parent()
	host.set_meta("component_manager", self)

	# Register every component.
	for c in get_children():
		if c is not Component: continue
		c.host = host
		c.manager = self
		components.append(c)

	# Validate _accepts().
	# TODO: this creates null refs because of inconsistent order so fix that.
	for c in components.duplicate():
		if not c._accepts(host):
			push_error("component: '%s' doesn't accept host: '%s'" % [c.name, host.name])
			c.process_mode = Node.PROCESS_MODE_DISABLED
			components.erase(c)

	# Initiate verified components.
	for c in components:
		c._component_ready()


func get_component(type: Script) -> Component:
	for c in components:
		if is_instance_of(c, type):
			return c
	return null


func has_component(type: Script) -> bool:
	return get_component(type) != null


func has_components(types: Array[Script]) -> bool:
	for t in types:
		if not has_component(t):
			return false
	return true


## Get ComponentManager of a node or null.
static func of(node: Node) -> ComponentManager:
	if node == null or not node.has_meta("component_manager"): return null
	return node.get_meta("component_manager", null) as ComponentManager
