@tool
extends Node3D

class_name CargoGrid

@export
var monitoring_distance : float

@export
var cargo_grid_physical_size : Vector3 :
	set(value):
		if Engine.is_editor_hint():
			cargo_grid_physical_size = value
			if $Area3D/CollisionShape3D != null:
				$Area3D/CollisionShape3D.shape.size = value

@export
var total_cu_capacity : int

@export
var cu_x_y_z : Vector3

@onready
var cargo_area : PackedScene = preload("res://classes/cargo/CargoArea.tscn")

var cargo_area_dictionary : Dictionary = {}

@export
var cargo_area_root : Node3D

var player : Player

var player_nearby : bool = false

@export
var generate_grid : bool :
	set(value):
		if value == true:
			var area : Area3D = $Area3D
			var collision_shape : CollisionShape3D = area.get_node("CollisionShape3D")
			var shape : Shape3D = collision_shape.shape
			_generate_box_grid(shape, area)

func _ready() -> void:
	if !Engine.is_editor_hint():
		cargo_area_dictionary.clear()

		player = get_tree().get_first_node_in_group("Player")

		for c : CargoArea in cargo_area_root.get_children():
			cargo_area_dictionary[c.area_coordinate] = c

		for c : CargoArea in cargo_area_root.get_children():
			var lower_cargo : CargoArea = find_cargo_area(c.area_coordinate - Vector3(0, 1, 0))
			var upper_cargo : CargoArea = find_cargo_area(c.area_coordinate + Vector3(0, 1, 0))

			if lower_cargo != null:
				c.lower_cargo_area = lower_cargo
				c.valid = false
			else:
				c.valid = true

			if upper_cargo != null:
				c.upper_cargo_area = upper_cargo

		var area : Area3D = $Area3D
		var collision_shape : CollisionShape3D = area.get_node("CollisionShape3D")
		var shape : Shape3D = collision_shape.shape

func find_cargo_area(coordinate : Vector3) -> CargoArea:
	return cargo_area_dictionary.get(coordinate, null)

var frame_skip: int = 0

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if frame_skip > 0:
			frame_skip -= 1
			return

		frame_skip = 60

		var is_nearby : bool = (player.global_position - self.global_position).length_squared() <= monitoring_distance

		if is_nearby != player_nearby:
			player_nearby = is_nearby

			for c : CargoArea in cargo_area_root.get_children():
				c.monitoring = is_nearby

func _generate_box_grid(box_shape: BoxShape3D, area: Area3D) -> void:
	for m : Node3D in cargo_area_root.get_children():
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
		for m : Node3D in cargo_area_root.get_children():
			m.position.y -= chunk_size / 2


	if x_chunks == 1:
		for m : Node3D in cargo_area_root.get_children():
			m.position.x -= chunk_size / 2


	if z_chunks == 1:
		for m : Node3D in cargo_area_root.get_children():
			m.position.z -= chunk_size / 2

	total_cu_capacity = y_chunks * x_chunks * z_chunks

func _add_shape_to_grid(chunk_size : float, chunk_center : Vector3, coordinate : Vector3) -> void:
	var area : CargoArea = cargo_area.instantiate()

	area.area_coordinate = coordinate
	area.cargo_grid = self

	cargo_area_root.add_child(area)
	area.global_position = chunk_center
	area.owner = get_tree().edited_scene_root
