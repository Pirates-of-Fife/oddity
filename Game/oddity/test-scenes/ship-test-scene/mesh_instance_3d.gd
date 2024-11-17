extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	# Sun's rotation (simplified)
	var equatorial_rotation_speed : float = 0.000167 # radians per second
	var polar_rotation_speed : float = 0.000113 # radians per second

	# Example: Rotate primarily on Y (equatorial) axis, slight tilt for X and Z
	rotate_x(0.00001 * delta) # Minimal rotation for axial tilt
	rotate_y(equatorial_rotation_speed * delta) # Dominant equatorial spin
	rotate_z(0.00001 * delta) # Minimal rotation for axial tilt
