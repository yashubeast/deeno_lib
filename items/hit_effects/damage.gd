extends HitEffect
class_name DamageHitEffect


@export var amount := 10.0


func apply(hit: HitContext) -> void:
	var health := HealthComponent.find_in(hit.collider)
	if health != null:
		health.take_damage(amount, hit.source)
