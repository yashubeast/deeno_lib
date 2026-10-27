@abstract
extends Resource
class_name ActionEffect
## Something that happens the moment an attack/action is fired/action'd, hit or not.


@abstract func apply(action: ActionContext) -> void
