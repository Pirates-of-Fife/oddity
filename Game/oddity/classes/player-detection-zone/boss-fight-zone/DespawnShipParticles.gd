extends GPUParticles3D

class_name DespawnShipParticles

var ship : Starship

func _process(delta: float) -> void:
	if ship != null:
		global_position = ship.global_position
		
func start() -> void:
	emitting = true
	
	await get_tree().create_timer(4).timeout
	
	if ship != null:
		ship.queue_free()
	
	emitting = false
	
	await get_tree().create_timer(1).timeout

	queue_free()
