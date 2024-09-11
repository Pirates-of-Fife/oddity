extends Node3D

func _on_player_input_send_movement_vector(movement_vector):
	$SubViewport/ThrustBar2D.value = abs(movement_vector.z * 100)
