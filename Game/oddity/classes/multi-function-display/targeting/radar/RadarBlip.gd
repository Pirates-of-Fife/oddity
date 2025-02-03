extends Node3D

class_name RadarBlip

@export
var line_mesh : MeshInstance3D

@export
var entity : GameEntity

@export
var default_material : StandardMaterial3D

@export
var selected_material : StandardMaterial3D

func _ready() -> void:
	var distance_to_zero : float = -position.y

	line_mesh.mesh.size.y = abs(distance_to_zero)
	line_mesh.position.y = distance_to_zero / 2
	
	set_default_material()

func _process(delta: float) -> void:
	var distance_to_zero : float = -position.y

	line_mesh.mesh.size.y = abs(distance_to_zero)
	line_mesh.position.y = distance_to_zero / 2
	
func set_target_material() -> void:
	$MeshInstance3D.set_surface_override_material(0, selected_material)
	line_mesh.set_surface_override_material(0, selected_material)
	
func set_default_material() -> void:
	$MeshInstance3D.set_surface_override_material(0, default_material)
	line_mesh.set_surface_override_material(0, default_material)

	#print(line_mesh.mesh.size.y)
