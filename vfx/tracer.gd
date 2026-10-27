extends RefCounted
class_name Tracer
## Fire and forget bullet tracer. Purely cosmetic.


static func spawn(
	anchor: Node,
	from: Vector3,
	to: Vector3,
	color := Color(1.0, 0.85, 0.4),
	width := 0.02,
	lifetime := 0.06
) -> MeshInstance3D:
	if not is_instance_valid(anchor): return null
	var dist := from.distance_to(to)
	if dist < 0.01: return null

	var mesh := BoxMesh.new()
	mesh.size = Vector3(width, width, dist) # long along Z

	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = color

	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.material_override = mat
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	anchor.get_tree().current_scene.add_child(node)
	node.global_position = (from + to) * 0.5 # box is centered, so use the midpoint

	var dir := (to - from).normalized()
	var up := Vector3.UP if absf(dir.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	node.look_at(to, up)

	# Fade out, then delete.
	var tween := node.create_tween()
	tween.tween_property(mat, "albedo_color:a", 0.0, lifetime)
	tween.tween_callback(node.queue_free)
	return node
