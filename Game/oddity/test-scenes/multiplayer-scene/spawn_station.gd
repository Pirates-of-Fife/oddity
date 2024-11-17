extends Node3D

func _process(delta: float) -> void:
	rotate_object_local(Vector3(0,1,0), 0.07 * delta)
