extends FogVolume

class_name CloudRotation

@export
var rotation_direction : Vector3 = Vector3.ZERO

@export_range(0, 2, 0.01)
var rotation_speed : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(rotation_direction.normalized(), rotation_speed * delta)
