extends RefCounted
class_name HitContext


var source: Node
var collider: Node
var position: Vector3
var normal: Vector3
var direction: Vector3


static func from_ray(src: Node, result: Dictionary, dir: Vector3) -> HitContext:
	var h := HitContext.new()
	h.source = src
	h.collider = result.collider as Node
	h.position = result.position as Vector3
	h.normal = result.normal as Vector3
	h.direction = dir
	return h
