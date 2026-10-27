extends Resource
class_name Item


@export var id: StringName
@export var display_name := "unnamed"
@export var icon: Texture2D
@export var max_stack := 1
## Spawned in the hand while selected.
@export var held_scene: PackedScene
@export var components: Array[ItemComponent] = []
