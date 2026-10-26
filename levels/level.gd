@abstract
extends Node3D
class_name Level
## Partially abstract class for levels


const DEFAULT_PLAYER_SPAWN_NAME := "%DefaultPlayerSpawn"


## Provides default global position for player to be placed in level.
## Looks for a Marker3D named "DefaultPlayerSpawn" (with "Access as Unique Name" enabled).
func get_default_player_spawn() -> Vector3:
	var spawn := get_node_or_null(DEFAULT_PLAYER_SPAWN_NAME) as Marker3D
	if spawn == null:
		push_error("Level '%s' has no Marker3D with unique name '%s'." %[name, DEFAULT_PLAYER_SPAWN_NAME])
		return Vector3.ZERO
	return spawn.global_position
