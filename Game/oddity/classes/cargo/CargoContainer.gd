extends GameEntity

class_name CargoContainer

@export_category("Cargo")

@export
var container_size : CargoUnit.ContainerSize

@export
var max_internal_freight_volume : int

@export
var cargo_units : int

# INFO Will be replaced by a resource file or something else
@export
var contents : String

@export
var snapping_point : Marker3D

# Snapping Mechanic

signal container_snapped
signal container_unsnapped
signal container_snapping_rotated(container : CargoContainer)

var in_cargo_areas : Array = Array()
var valid_placement_positions : Array = Array()

var container_cu_shape : Vector3

var nearest_cargo_area : CargoArea = null

var snapped_areas: Array = []

var rotation_index: int = 3 # Tracks the current rotation orientation
var rotations : Array = [Vector3(0, deg_to_rad(90), 0), Vector3(0, 0, deg_to_rad(90)), Vector3(deg_to_rad(90), 0, 0), Vector3.ZERO]

func calculate_valid_placement_positions() -> void:
	valid_placement_positions.clear()

	for c : CargoArea in in_cargo_areas:
		if c.valid == true:
			var placement : Array = c.find_cargo_areas_from_shape(container_cu_shape)
			print("Placement: " + str(placement))
			if c.is_placement_valid(placement):
				valid_placement_positions.append(placement)

func _ready() -> void:
	_cargo_container_ready()

func _process(delta: float) -> void:
	_cargo_container_process(delta)

	if is_being_held and in_cargo_areas.size() > 0 and valid_placement_positions.size() > 0:
		(in_cargo_areas[0].cargo_grid as CargoGrid).highlight_cargo_areas(valid_placement_positions[0])

	if !is_being_held and in_cargo_areas.size() > 0 and valid_placement_positions.size() > 0:
		print("snapping")
		snap_to_grid(valid_placement_positions[0])

func _cargo_container_ready() -> void:
	_default_ready()
	_initialize_collision_shape()
	container_cu_shape = (CargoUnit.new()).get_container_size(container_size) * 0.8

func _cargo_container_process(delta : float) -> void:
	_default_process(delta)

func snap_to_grid(cargo_areas: Array) -> void:
	if cargo_areas.size() != cargo_units:
		return

	if snapped_areas.size() == 0  or cargo_areas.is_empty():
		return

	if cargo_areas.is_empty():
		return

	freeze_static()

	var total_position: Vector3 = Vector3()

	for cargo_area : CargoArea in cargo_areas:
		total_position += cargo_area.global_position

	var center_position: Vector3 = total_position / cargo_areas.size()
	var center_rotation: Vector3 = cargo_areas[0].global_rotation + rotations[rotation_index]

	global_position = center_position
	global_rotation = center_rotation

	for cargo_area : CargoArea in cargo_areas:
		cargo_area.snapped_cargo = self

	snapped_areas = cargo_areas

	for cargo_area : CargoArea in cargo_areas:
		cargo_area.cargo_added()
		cargo_area.highlight_off()

	container_snapped.emit()

# Updated `unsnap_from_grid` function
func unsnap_from_grid() -> void:
	if snapped_areas.is_empty():
		return

	# Notify each cargo area that the cargo has been removed
	for cargo_area : CargoArea in snapped_areas:
		cargo_area.cargo_removed()
		cargo_area.snapped_cargo = null

	# Clear the snapped areas and reset the state
	snapped_areas.clear()

	container_unsnapped.emit()


func rotate_cargo() -> void:
	rotation_index = (rotation_index + 1) % rotations.size()

	var container_cu : Vector3 = (CargoUnit.new()).get_container_size(container_size)

	match rotation_index:
		0:
		# Rotation around Y-axis
			container_cu_shape = Vector3(container_cu.z, container_cu.y, container_cu.x) * 0.8
		1:
		# Rotation around Z-axis
			container_cu_shape = Vector3(container_cu.y, container_cu.x, container_cu.z) * 0.8
		2:
		# Rotation around X-axis
			container_cu_shape = Vector3(container_cu.x, container_cu.z, container_cu.y) * 0.8
		3:
		# No rotation
			container_cu_shape = container_cu * 0.8
	calculate_valid_placement_positions()
	container_snapping_rotated.emit(self)

func find_nearest_cargo_area() -> void:
	var closest_area : CargoArea = null
	var shortest_distance : float = INF

#	if nearest_cargo_area != null:
#		nearest_cargo_area.cargo_grid.highlight_off_cargo_areas(nearest_cargo_area.cargo_areas_for_container)

	#print(in_cargo_areas)

	for area : CargoArea in in_cargo_areas:
		if area != null:
			if area.valid:
				var distance : float = snapping_point.global_position.distance_to(area.global_position)

				if distance < shortest_distance:
					shortest_distance = distance
					closest_area = area

	nearest_cargo_area = closest_area
		#container_snapping_rotated.emit(self)


	#if nearest_cargo_area != null:
	#	nearest_cargo_area.highlight_cargo()


func on_interact_self() -> void:
	if !snapped_areas.is_empty():
		unsnap_from_grid()

	unfreeze()

func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()

	var cargo_unit : CargoUnit = CargoUnit.new()

	box_shape.size = cargo_unit.get_container_size(container_size)

	var collision_shape : CollisionShape3D = CollisionShape3D.new()

	collision_shape.shape = box_shape

	collision_shape.name = "CollisionShape3D"

	add_child(collision_shape)
