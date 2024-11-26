@tool
extends Node3D

class_name CargoGrid

@export
var cargo_grid_physical_size : Vector3 :
	set(value):
		cargo_grid_physical_size = value
		if $Area3D/CollisionShape3D != null:
			$Area3D/CollisionShape3D.shape.size = value

@export
var total_cu_capacity : int

@export
var cu_x_y_z : Vector3

@export
var cargo_area : PackedScene

@export
var generate_grid : bool :
	set(value):
		if value == true:
			var area : Area3D = $Area3D
			var collision_shape : CollisionShape3D = area.get_node("CollisionShape3D")
			var shape : Shape3D = collision_shape.shape
			_generate_box_grid(shape, area)

func find_cargo_area(coordinate : Vector3) -> CargoArea:
	for c : CargoArea in $Markers.get_children():
		if c.area_coordinate == coordinate:
			return c
	
	return null

func _generate_box_grid(box_shape: BoxShape3D, area: Area3D) -> void:
	for m : Node3D in $Markers.get_children():
		m.queue_free()

	var chunk_size : float = 1.25  # 1 CU size

	# Get box dimensions (centered on origin)
	var box_size : Vector3 = box_shape.size
	var area_origin : Vector3 = area.global_transform.origin

	# Calculate grid bounds
	var x_chunks : int = int(box_size.x / chunk_size)
	var y_chunks : int = int(box_size.y / chunk_size)
	var z_chunks : int = int(box_size.z / chunk_size)

	cu_x_y_z = Vector3(x_chunks, y_chunks, z_chunks)


	# Iterate through chunks
	for x : float in range(ceilf(-x_chunks / 2.0), ceilf(x_chunks / 2.0)):
		for y : float in range(ceilf(-y_chunks / 2.0), ceilf(y_chunks / 2.0)):
			for z : float in range(ceilf(-z_chunks / 2.0), ceilf(z_chunks / 2.0)):
				# Compute position of the current chunk
				var chunk_center : Vector3 = area_origin + Vector3(
					x * chunk_size + chunk_size / 2,
					y * chunk_size + chunk_size / 2,
					z * chunk_size + chunk_size / 2
				)

				_add_shape_to_grid(chunk_size, chunk_center, Vector3(x, y, z))


	if y_chunks == 1:
		for m : Node3D in $Markers.get_children():
			m.position.y -= chunk_size / 2


	if x_chunks == 1:
		for m : Node3D in $Markers.get_children():
			m.position.x -= chunk_size / 2


	if z_chunks == 1:
		for m : Node3D in $Markers.get_children():
			m.position.z -= chunk_size / 2

	total_cu_capacity = y_chunks * x_chunks * z_chunks


func _add_shape_to_grid(chunk_size : float, chunk_center : Vector3, coordinate : Vector3) -> void:
	var area : CargoArea = cargo_area.instantiate()
	area.area_coordinate = coordinate
	area.cargo_grid = self
	
	$Markers.add_child(area)
	area.global_position = chunk_center
	area.owner = get_tree().edited_scene_root
