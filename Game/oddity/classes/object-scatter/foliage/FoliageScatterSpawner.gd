@tool
extends ObjectScatterSpawner

class_name FoliageScatterSpawner

@export_category("Foliage")

@export
var foliage_meshes : Array[FoliageResource] = []

func spawn_gas_giant_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	for foliage : FoliageResource in foliage_meshes:
		var sectors : Array = object_scatter.generate_gas_giant_scatter_sectors(splits, count_per_multi_mesh, planet_radius + atmosphere_padding_radius, foliage.scale_multiplier, invert_scale, foliage.scale_variance, density)
	
		spawn_objects(sectors, foliage.foliage_mesh)

func spawn_asteroid_belt_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	for foliage : FoliageResource in foliage_meshes:
		var sectors : Array = object_scatter.generate_asteroid_belt_scatter_sectors(splits, count_per_multi_mesh, asteroid_belt, foliage.scale_multiplier, invert_scale, foliage.scale_variance, vertical_variance)

		spawn_objects(sectors, foliage.foliage_mesh)

func spawn_planet_surface_sectors() -> void:
	var object_scatter : ObjectScatter = ObjectScatter.new()
	
	for foliage : FoliageResource in foliage_meshes:

		var sectors : Array = object_scatter.generate_planet_scatter_sectors(splits, count_per_multi_mesh, planet_radius, foliage.scale_multiplier, invert_scale, foliage.scale_variance)
	
		spawn_objects(sectors, foliage.foliage_mesh)

func spawn_objects(sectors : Array, mesh : ArrayMesh) -> void:
	var i : int = 0
	for sector : ScatterSector in sectors:
		i += 1
		var sector_node : Node3D = Node3D.new()
		
		root.add_child(sector_node)
		
		sector_node.owner = get_tree().edited_scene_root
		sector_node.name = "Sector_%d" % i
		
		var sector_node_root : Node3D = Node3D.new()
		sector_node.add_child(sector_node_root)
		
		var mmi : MultiMeshInstance3D = MultiMeshInstance3D.new()
		sector_node.add_child(mmi)
		mmi.owner = get_tree().edited_scene_root
		
		var mm : MultiMesh = MultiMesh.new()
		mm.mesh = mesh
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.instance_count = sector.transforms.size()
		
		var j : int = 0
		for t : Transform3D in sector.transforms:
			var local_t : Transform3D = Transform3D(t)
			local_t.origin = sector_node.to_local(local_t.origin)
			mm.set_instance_transform(j, local_t)
			j += 1
		
		mmi.multimesh = mm
