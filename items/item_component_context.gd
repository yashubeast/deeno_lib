extends RefCounted
class_name ItemComponentContext


var holder: HolderComponent
var stack: ItemStack
var aim: Node3D
var muzzle: Node3D
var host: Node:
	get: return holder.host


## Where the thing visually starts. Falls back to the aim if theres no muzzle.
func get_origin() -> Vector3:
	return muzzle.global_position if muzzle != null else aim.global_position


## Where the holder is looking.
func get_direction() -> Vector3:
	return -aim.global_basis.z
