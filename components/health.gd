extends Component
class_name HealthComponent


signal health_changed(current: float, maximum: float)
signal damaged(amount: float, source: Node)
signal died(source: Node)

@export var max_health := 100.0
@export var queue_free_on_death := true
var health := 0.0
var is_dead := false


func _component_ready() -> void:
	health = max_health
	health_changed.emit(health, max_health)


func take_damage(amount: float, source: Node = null) -> void:
	if is_dead or amount <= 0.0: return
	health = maxf(health - amount, 0.0)
	damaged.emit(amount, source)
	health_changed.emit(health, max_health)
	if health == 0.0:
		is_dead = true
		died.emit(source)
		if queue_free_on_death: host.queue_free()


static func find_in(node: Node) -> HealthComponent:
	while node != null:
		var cm := ComponentManager.of(node)
		if cm != null: return cm.get_component(HealthComponent) as HealthComponent
		node = node.get_parent()
	return null
