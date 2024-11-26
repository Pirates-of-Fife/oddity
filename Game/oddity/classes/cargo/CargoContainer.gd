extends GameEntity

class_name CargoContainer

@export_category("Cargo")

@export
var container_size : CargoUnit.ContainerSize

var in_cargo_areas : Array = Array()

var nearest_cargo_area : CargoArea = null

# INFO Will be replaced by a resource file or something else
@export
var contents : String

func _ready() -> void:
	_cargo_container_ready()

func _process(delta: float) -> void:
	_cargo_container_process(delta)

func _cargo_container_ready() -> void:
	_default_ready()
	_initialize_collision_shape()

func _cargo_container_process(delta : float) -> void:
	_default_process(delta)

	if is_being_held and in_cargo_areas.size() > 0:
		find_nearest_cargo_area()

func find_nearest_cargo_area() -> void:
	var closest_area : CargoArea = null
	var shortest_distance : float = INF  # Start with a very large number (infinity)

	# Loop through all the cargo areas in the container's `in_cargo_areas` list
	for area : CargoArea in in_cargo_areas:
		if area != null:
		# Calculate the distance between the cargo container and this cargo area
			var distance : float = global_position.distance_to(area.global_position)

			# If this area is closer than the current closest, update
			if distance < shortest_distance:
				shortest_distance = distance
				closest_area = area

	nearest_cargo_area = closest_area

func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()

	var cargo_unit : CargoUnit = CargoUnit.new()

	box_shape.size = cargo_unit.get_container_size(container_size)

	var collision_shape : CollisionShape3D = CollisionShape3D.new()

	collision_shape.shape = box_shape

	add_child(collision_shape)
