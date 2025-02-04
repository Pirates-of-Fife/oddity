extends StaticGameEntity

@export
var mesh : CollisionShape3D

@export
var rotation_speed : float

func _process(delta: float) -> void:
	mesh.rotate_x(rotation_speed * delta)
