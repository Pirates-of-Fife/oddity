@tool
extends Node3D

class_name ObjectScatterSpawner

@export_category("Spawn Settings")

@export
var spawn_type : SpawnType = SpawnType.PLANET

@export_range(1, 200, 1)
var splits : int = 1

@export_range(100, 20000, 100)
var spawn_count : int

@export_range(100, 1000, 50)
var spawn_radius : float

@export
var count_per_multi_mesh : int :
	get():
		return spawn_count / splits

@export
var scale_multiplier : float = 1

@export_range(0, 1, 0.01)
var scale_variance : float = 0

@export
var invert_scale : bool = false

@export
var root : SectorRootNode

@export_category("Planet Information")

@export_subgroup("Planet")

@export
var planet_mesh_instance : MeshInstance3D : 
	set(value):
		planet_mesh_instance = value
		
		if planet_mesh_instance.mesh is SphereMesh:
			planet_mesh = planet_mesh_instance.mesh
			planet_radius = planet_mesh.radius
	get():
		return planet_mesh_instance

var planet_mesh : SphereMesh

var planet_radius : float

@export_subgroup("Asteroid Belt")

@export
var asteroid_belt : AsteroidBelt

@export_range(0, 1000, 5)
var vertical_variance : float = 0

@export_category("Functions")

@export
var spawn : bool :
	set(value):
		if Engine.is_editor_hint():
			clear_sector_root()
			spawn_sectors()

@export
var clear : bool :
	set(value):
		if Engine.is_editor_hint():
			clear_sector_root()
			

func spawn_sectors() -> void:
	match spawn_type:
		SpawnType.ASTEROID_BELT:
			spawn_asteroid_belt_sectors()
		SpawnType.PLANET:
			spawn_planet_surface_sectors()
		SpawnType.GAS_GIANT:
			spawn_gas_giant_sectors()

func spawn_planet_surface_sectors() -> void:
	printerr("Not Implemented")

func spawn_asteroid_belt_sectors() -> void:
	printerr("Not Implemented")

func spawn_gas_giant_sectors() -> void:
	printerr("Not Implemented")

func clear_sector_root() -> void:
	for i : Node in root.get_children():
		i.queue_free()

enum SpawnType
{
	ASTEROID_BELT,
	PLANET,
	GAS_GIANT
}
