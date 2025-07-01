@tool
extends ObjectScatterSpawner

class_name MineableSpawner

@export_category("Mineable")

@export
var mineable_resource : MineableResource

func spawn_planet_surface_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	var sectors : Array = object_scatter.generate_planet_scatter_sectors(splits, count_per_multi_mesh, planet_radius, scale_multiplier, invert_scale, 0)
	var mesh : ArrayMesh = mineable_resource.low_detail_mesh
	
	var i : int = 0
	for sector : ScatterSector in sectors:
		i += 1
		#var sector_node : MineableSector = MineableSector.new()
		var sector_node : Node3D = Node3D.new()
		root.add_child(sector_node)
		
		sector_node.owner = get_tree().edited_scene_root
		sector_node.name = "Sector_%d" % i
		var average : Vector3 = sector.average_position
		#sector_node.mineable_resource = mineable_resource
		
		#var sector_node_root : Node3D = Node3D.new()
		#sector_node.add_child(sector_node_root)
		#sector_node.update_rate = 0.5
		#sector_node.mineable_spawn_root = sector_node_root
		#sector_node_root.owner = get_tree().edited_scene_root
		sector_node.position = average
		
		var mmi : MultiMeshInstance3D = MultiMeshInstance3D.new()
		sector_node.add_child(mmi)
		#root_node.add_child(mmi)
		mmi.owner = get_tree().edited_scene_root
		#mmi.custom_aabb = AABB(Vector3(-10000,-10000,-10000), Vector3(20000,20000,20000))
		#mmi.custom_aabb = calculate_multimesh_aabb(mineable_resource.low_detail_mesh, sector.positions)
		#print(mineable_resource.low_detail_mesh.get_aabb())
		
		#mmi.position = average
		
		
		var mm : MultiMesh = MultiMesh.new()
		mm.mesh = mesh
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.instance_count = sector.transforms.size()
		
		
		var j : int = 0
		for t : Transform3D in sector.transforms:
			#sector_node.append_transform(t)
			#t.origin = mmi.to_local(t.origin)
			var local_t : Transform3D = Transform3D(t)
			local_t.origin = sector_node.to_local(local_t.origin)
			mm.set_instance_transform(j, local_t)
			j += 1
			
		mmi.multimesh = mm
		print(mmi.get_aabb())

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
