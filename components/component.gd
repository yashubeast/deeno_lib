extends Node
class_name Component


var host: Node
var manager: ComponentManager


## Wheather the host is accepted by the component.
## Example: return host is PlayerControllerComponent.
## Process of the component node is disabled if this returns false.
## You CAN access sibling components in this function.
## Making it possible for components to run only if other components are present.
func _accepts(_host: Node) -> bool:
	return true # Accept every node by default


## Runs after every component has been registered.
## So siblings can look up each other.
func _component_ready() -> void:
	pass
