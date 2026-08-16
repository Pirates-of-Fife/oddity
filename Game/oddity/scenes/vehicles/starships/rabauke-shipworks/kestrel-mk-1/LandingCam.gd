extends Camera3D

@export
var ships : Starship

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = ships.landing_cam_marker.global_position
	global_rotation = ships.landing_cam_marker.global_rotation
