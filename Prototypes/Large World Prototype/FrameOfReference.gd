extends Node3D

@export
var reference_object : Node3D

func _process(delta):
	if (reference_object.global_position.length() < 190000):
		#global_position = reference_object.global_position
		#global_rotation = reference_object.global_rotation
		#rotate(Vector3(1, 0, 0), 0.0002)	
		print("using Planet")
	else:
		#global_position = Vector3.ZERO
		#global_rotation = Vector3.ZERO
		print("using 0")
