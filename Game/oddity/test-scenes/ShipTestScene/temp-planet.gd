extends Node3D

func _process(delta: float) -> void:
	rotate(Vector3(0,0,1), 0.05 * delta)
	
	global_position.y += 0.01 * delta
