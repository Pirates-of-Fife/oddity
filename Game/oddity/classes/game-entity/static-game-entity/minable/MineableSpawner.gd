@tool
extends Node3D

class_name MineableSpawner

@export_category("Spawn Settings")

@export
var spawn_type : SpawnType = SpawnType.PLANET

@export_range(1, 20, 1)
var splits : int = 1

@export_range(100, 20000, 100)
var spawn_count : int

@export
var count_per_multi_mesh : int :
	get():
		return spawn_count / splits

@export
var root_node : Node3D

@export_category("Mineable")

@export
var mineable_resource : MineableResource

@export_category("Planet")

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


@export
var multimesh : MultiMeshInstance3D

@export_category("Buttons")

@export
var spawn : bool :
	set(value):
		clear_current_mineables()
		spawn_mineables()

@export
var clear : bool :
	set(value):
		clear_current_mineables()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func spawn_mineables() -> void:
	match spawn_type:
		SpawnType.ASTEROID_BELT:
			spawn_mineables_in_asteroid_belt()
		SpawnType.PLANET:
			spawn_mineables_on_planet_surface()
		SpawnType.GAS_GIANT:
			spawn_mineables_in_gas_giant()

func spawn_mineables_on_planet_surface() -> void:
	var sectors : Array = generate_sector_positions()
	var mesh : ArrayMesh = mineable_resource.low_detail_mesh

	var i : int = 0
	for sector : Sector in sectors:
		i += 1
		var sector_node : Node3D = Node3D.new()
		sector_node.name = str(i)
		root_node.add_child(sector_node)
		sector_node.owner = get_tree().edited_scene_root
		
		for t : Transform3D in sector.positions:
			var mesh_instance_3d : MeshInstance3D = MeshInstance3D.new()
			mesh_instance_3d.mesh = mesh
			
			sector_node.add_child(mesh_instance_3d)
			mesh_instance_3d.transform = t
			mesh_instance_3d.owner = get_tree().edited_scene_root
			mesh_instance_3d.scale = Vector3(3,3,3)
			
			mesh_instance_3d.owner = get_tree().edited_scene_root
		
		#print(i.positions)

func generate_sector_positions() -> Array:
	var sectors : Array = Array()
	
	var lattitude_splits : int = splits / 2
	var longitude_splits : int = splits / 2
	
	
	print(lattitude_splits)
	print(longitude_splits)
	
	var radius : float = planet_radius - 1
	
	for lattitude_index : int in range(lattitude_splits):
		var lat_min : float = lerpf(-PI / 2.0, PI / 2.0, float(lattitude_index) / lattitude_splits)
		var lat_max : float = lerpf(-PI, PI, float(lattitude_index + 1) / lattitude_splits)
		
		for longitude_index : int in range(longitude_splits):
			var lon_min : float = lerp(-PI, PI, float(longitude_index) / longitude_splits)
			var lon_max : float = lerp(-PI, PI, float(longitude_index + 1) / longitude_splits)
		
			var sector : Sector = Sector.new()
			
			sector.lat_min = lat_min
			sector.lat_max = lat_max
			sector.lon_min = lon_min
			sector.lon_max = lon_max
		
			for i : int in count_per_multi_mesh:
				var lat : float = randf_range(lat_min, lat_max)
				var lon : float = randf_range(lon_min, lon_max)
				
				var x : float = radius * cos(lat) * cos(lon)
				var y : float = radius * sin(lat)
				var z : float = radius * cos(lat) * sin(lon)
				var pos : Vector3 = Vector3(x, y, z)
				
				var up : Vector3 = pos.normalized()
				var tangent : Vector3 = up.cross(Vector3.UP)
				
				if tangent.length() < 0.1:
					tangent = up.cross(Vector3(1, 0, 0))
				
				tangent = tangent.normalized()
				
				var right : Vector3 = tangent.cross(up).normalized()
				var forward : Vector3 = up.cross(right).normalized()
				
				var spawn_xform : Transform3D = Transform3D()
				spawn_xform.basis.x = right
				spawn_xform.basis.y = up
				spawn_xform.basis.z = forward
				spawn_xform.origin = pos
				
				sector.positions.append(spawn_xform)
				
			sectors.append(sector)
			print(sectors.size())
			
	return sectors

class Sector:
	var positions: Array = Array()
	var lat_min: float
	var lat_max: float
	var lon_min: float
	var lon_max: float

func spawn_mineables_in_gas_giant() -> void:
	pass
	
func spawn_mineables_in_asteroid_belt() -> void:
	pass

	
func clear_current_mineables() -> void:
	for i : Node in root_node.get_children():
		i.queue_free()

enum SpawnType
{
	ASTEROID_BELT,
	PLANET,
	GAS_GIANT
}
