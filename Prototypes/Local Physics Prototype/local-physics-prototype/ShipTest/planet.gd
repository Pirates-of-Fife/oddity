extends Node3D

func _process(delta: float) -> void:
	rotate_y(0.05 * delta)
	global_position.y += 0.01 * delta
	pass
