@tool
extends Node3D

class_name MineableSpawner

@export_category("Spawn Settings")

@export
var spawn_type : SpawnType = SpawnType.PLANET

@export_range(1, 200, 1)
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

@export
var scale_multiplier : float = 1

@export
var invert_scale : bool = false

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

@export_category("Buttons")

@export
var spawn : bool :
	set(value):
		if Engine.is_editor_hint():
			clear_current_mineables()
			spawn_mineables()

@export
var clear : bool :
	set(value):
		if Engine.is_editor_hint():
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
		#var sector_node : MineableSector = MineableSector.new()
		#root_node.add_child(sector_node)
		#sector_node.owner = get_tree().edited_scene_root
		#sector_node.name = "Sector_%d" % i
		
		#sector_node.mineable_resource = mineable_resource
		
		#var sector_node_root : Node3D = Node3D.new()
		#sector_node.add_child(sector_node_root)
		#sector_node.update_rate = 0.5
		#sector_node.mineable_spawn_root = sector_node_root
		#sector_node_root.owner = get_tree().edited_scene_root
		
		var mmi : MultiMeshInstance3D = MultiMeshInstance3D.new()
		#vector_node.add_child(mmi)
		root_node.add_child(mmi)
		mmi.owner = get_tree().edited_scene_root
		
		var mm : MultiMesh = MultiMesh.new()
		mm.mesh = mesh
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.instance_count = sector.positions.size()
		
		
		var j : int = 0
		for t : Transform3D in sector.positions:
			#sector_node.append_transform(t)
			mm.set_instance_transform(j, t)
			j += 1

			
		mmi.multimesh = mm
		
		#var average : Vector3 = calculate_average_positions(sector_node.mineable_transforms)
		#var bounding_radius : float = calculate_bounding_radius(sector_node.mineable_transforms) + sector_node.spawn_radius
		
		#var zone : PlayerDetectionZone = PlayerDetectionZone.new()
		#zone.activate_distance = bounding_radius
		#zone.deactivate_distance = bounding_radius + 100
		
		#sector_node.add_child(zone)
		#sector_node.zone = zone
		
		#zone.position = average
		
		#zone.owner = get_tree().edited_scene_root
		
		#print(i.positions)

func calculate_average_positions(array : Array) -> Vector3:	
	if array.is_empty():
		return Vector3.ZERO

	var sum : Vector3 = Vector3.ZERO
	for xform : MineableSector.MineableTransform in array:
		sum += xform.mineable_transform.origin

	return sum / array.size()

func calculate_bounding_radius(array: Array) -> float:	
	if array.is_empty():
		return 0.0

	var center : Vector3 = calculate_average_positions(array)
	var max_dist_squared : float = 0.0

	for xform : MineableSector.MineableTransform in array:
		var pos : Vector3 = xform.mineable_transform.origin
		var dist_squared : float = center.distance_squared_to(pos)
		if dist_squared > max_dist_squared:
			max_dist_squared = dist_squared

	return sqrt(max_dist_squared)


func generate_sector_positions() -> Array:
	var sectors : Array = Array()
	
	var lattitude_splits : int = splits / 2
	var longitude_splits : int = splits / 2
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
				spawn_xform.basis.x = right * scale_multiplier
				spawn_xform.basis.y = up * scale_multiplier
				spawn_xform.basis.z = forward * scale_multiplier
				spawn_xform.origin = pos
				
				if invert_scale:
					spawn_xform = spawn_xform.scaled(Vector3(-1,-1,-1))
				#print(spawn_xform.basis.get_scale())
				
				sector.positions.append(spawn_xform)
				
			sectors.append(sector)
			
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

	
