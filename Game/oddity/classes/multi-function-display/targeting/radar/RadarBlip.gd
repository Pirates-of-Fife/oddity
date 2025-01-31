extends Node3D

class_name RadarBlip

@export
var line_mesh : MeshInstance3D

func _ready() -> void:
	var distance_to_zero : float = -position.y

	line_mesh.mesh.size.y = abs(distance_to_zero)
	line_mesh.position.y = distance_to_zero / 2

func _process(delta: float) -> void:
	var distance_to_zero : float = -position.y

	line_mesh.mesh.size.y = abs(distance_to_zero)
	line_mesh.position.y = distance_to_zero / 2

	print(line_mesh.mesh.size.y)
