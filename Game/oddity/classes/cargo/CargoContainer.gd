extends GameEntity

class_name CargoContainer

@export_category("Cargo")

@export
var container_size : CargoUnit.ContainerSize

var container_cu_shape : Vector3

@export
var max_internal_freight_volume : int

@export
var cargo_units : int

var in_cargo_areas : Array = Array()

var nearest_cargo_area : CargoArea = null

var snapped_to : CargoArea

signal container_snapped
signal container_unsnapped

# INFO Will be replaced by a resource file or something else
@export
var contents : String

# Add this variable to the CargoContainer class
var snapped_areas: Array = []

func _ready() -> void:
	_cargo_container_ready()

func _process(delta: float) -> void:
	_cargo_container_process(delta)

func _cargo_container_ready() -> void:
	_default_ready()
	_initialize_collision_shape()
	container_cu_shape = (CargoUnit.new()).get_container_size(container_size) * 0.8

func _cargo_container_process(delta : float) -> void:
	_default_process(delta)

func snap_to_grid(cargo_areas: Array) -> void:
	if cargo_areas.size() != cargo_units:
		return

	if snapped_to != null or cargo_areas.is_empty():
		return

	# Ensure all elements in cargo_areas are valid CargoArea objects
	if cargo_areas.is_empty():
		return

	# Freeze the current object and defer reparenting
	freeze_static()

	# Calculate the average global position and rotation
	var total_position: Vector3 = Vector3()
	var total_rotation: Vector3 = Vector3()

	for cargo_area : CargoArea in cargo_areas:
		total_position += cargo_area.global_position
		total_rotation += cargo_area.global_rotation

	var center_position: Vector3 = total_position / cargo_areas.size()
	var center_rotation: Vector3 = total_rotation / cargo_areas.size()

	# Update global position and rotation to the center
	global_position = center_position
	global_rotation = center_rotation

	# Snap to the provided cargo areas
	for cargo_area : CargoArea in cargo_areas:
		cargo_area.snapped_cargo = self

	# Update the snapped_to array to track snapped cargo areas
	snapped_areas = cargo_areas

	# Call the `cargo_added` method for each cargo area
	for cargo_area : CargoArea in cargo_areas:
		cargo_area.cargo_added()

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

var rotation_index: int = 0 # Tracks the current rotation orientation
var rotation_axes: Array = [Vector3.UP, Vector3.RIGHT, Vector3.FORWARD] # Rotation directions

func rotate_cargo() -> void:
	print("ROTATE")

	container_cu_shape = abs(container_cu_shape.rotated(rotation_axes[rotation_index], deg_to_rad(90)))


	print(container_cu_shape)

	# Step 4: Increment the rotation index (cycle through 0, 1, 2)
	rotation_index = (rotation_index + 1) % rotation_axes.size()


func find_nearest_cargo_area() -> void:
	var closest_area : CargoArea = null
	var shortest_distance : float = INF

	if nearest_cargo_area != null:
		nearest_cargo_area.highlight_off_cargo_areas(nearest_cargo_area.cargo_areas_for_container)

	#print(in_cargo_areas)

	for area : CargoArea in in_cargo_areas:
		if area != null:
			if area.valid:
				var distance : float = global_position.distance_to(area.global_position)

				if distance < shortest_distance:
					shortest_distance = distance
					closest_area = area

	nearest_cargo_area = closest_area
	if nearest_cargo_area != null:
		nearest_cargo_area.highlight_cargo()


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

	add_child(collision_shape)
