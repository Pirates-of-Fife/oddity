extends GPUParticles3D

class_name DespawnShipParticles

var ship : Starship
var follow_ship : bool = true

func _process(delta: float) -> void:
	if ship != null and follow_ship:
		global_position = ship.global_position
		
func start() -> void:
	emitting = true
	
	await get_tree().create_timer(4).timeout
	
	if ship != null:
		follow_ship = false
		
		ship.global_position = Vector3.ZERO
		
		await get_tree().create_timer(0.5).timeout
		
		ship.queue_free()
	
	emitting = false
	
	await get_tree().create_timer(1).timeout

	queue_free()
