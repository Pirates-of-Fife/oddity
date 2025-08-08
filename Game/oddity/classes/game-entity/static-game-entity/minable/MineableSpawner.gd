@tool
extends ObjectScatterSpawner

class_name MineableSpawner

@export_category("Mineable")

@export
var mineable_resource : MineableResource

func spawn_gas_giant_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	var sectors : Array = object_scatter.generate_gas_giant_scatter_sectors(splits, count_per_multi_mesh, planet_radius + atmosphere_padding_radius, scale_multiplier, invert_scale, scale_variance, density)
	
	spawn_objects(sectors)

func spawn_asteroid_belt_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	var sectors : Array = object_scatter.generate_asteroid_belt_scatter_sectors(splits, count_per_multi_mesh, asteroid_belt, scale_multiplier, invert_scale, scale_variance, vertical_variance)

	spawn_objects(sectors)

func spawn_planet_surface_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	var sectors : Array = object_scatter.generate_planet_scatter_sectors(splits, count_per_multi_mesh, planet_radius, scale_multiplier, invert_scale, scale_variance)
	
	spawn_objects(sectors)

func spawn_objects(sectors : Array) -> void:
	var mesh : ArrayMesh = mineable_resource.low_detail_mesh

	var i : int = 0
	for sector : ScatterSector in sectors:
		i += 1
		var sector_node : MineableSector = MineableSector.new()
		
		root.add_child(sector_node)
		
		sector_node.owner = get_tree().edited_scene_root
		sector_node.name = "Sector_%d" % i
		var average : Vector3 = sector.average_position
		sector_node.mineable_resource = mineable_resource
		
		var sector_node_root : Node3D = Node3D.new()
		sector_node.add_child(sector_node_root)
		sector_node.update_rate = 0.5
		sector_node.spawn_radius = spawn_radius
		sector_node.mineable_spawn_root = sector_node_root
		sector_node_root.owner = get_tree().edited_scene_root
		sector_node.position = average
		
		var mmi : MultiMeshInstance3D = MultiMeshInstance3D.new()
		sector_node.add_child(mmi)
		mmi.owner = get_tree().edited_scene_root
		
		var mm : MultiMesh = MultiMesh.new()
		mm.mesh = mesh
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.instance_count = sector.transforms.size()
		
		
		var j : int = 0
		for t : Transform3D in sector.transforms:
			sector_node.append_transform(t)
			var local_t : Transform3D = Transform3D(t)
			local_t.origin = sector_node.to_local(local_t.origin)
			mm.set_instance_transform(j, local_t)
			j += 1
		
		mmi.multimesh = mm

		var bounding_radius : float = sector.bounding_radius + sector_node.spawn_radius
		
		var zone : PlayerDetectionZone = PlayerDetectionZone.new()
		zone.activate_distance = bounding_radius
		zone.deactivate_distance = bounding_radius + 100
		
		sector_node.add_child(zone)
		sector_node.zone = zone
		
		zone.global_position = sector_node.global_position
		
		zone.owner = get_tree().edited_scene_root
