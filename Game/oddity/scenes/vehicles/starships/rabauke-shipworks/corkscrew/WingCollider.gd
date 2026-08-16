extends CollisionShape3D

@export
var wing_mesh : MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = wing_mesh.global_position
	global_rotation = wing_mesh.global_rotation
