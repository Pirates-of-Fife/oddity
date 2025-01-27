extends GameEntity

class_name CargoContainer

@export_category("Cargo")

signal snapped_to_grid(cargo_area : CargoArea, cargo_grid : CargoGrid)
signal snapped_out_of_grid(cargo_area : CargoArea, cargo_grid : CargoGrid)

@export
var container_size : CargoUnit.ContainerSize

var in_cargo_areas : Array = Array()

var nearest_cargo_area : CargoArea = null

var snapped_to : CargoArea

# INFO Will be replaced by a resource file or something else
@export
var contents : String

@export
var value : int

@export
var initialize_collision_shape_automatically : bool = true

enum CargoContainerDirection
{
	X,
	Y,
	Z
}

func _ready() -> void:
	_cargo_container_ready()

func _process(delta: float) -> void:
	_cargo_container_process(delta)

func _cargo_container_ready() -> void:
	_default_ready()
	
	if initialize_collision_shape_automatically:
		_initialize_collision_shape()

func _cargo_container_process(delta : float) -> void:
	_default_process(delta)

	if is_being_held and in_cargo_areas.size() > 0:
		find_nearest_cargo_area()

func snap_to_grid(cargo_area : CargoArea) -> void:
	if snapped_to != null:
		return

	freeze_static()
	reparent.call_deferred(cargo_area)
	global_position = cargo_area.global_position
	global_rotation = cargo_area.global_rotation
	cargo_area.snapped_cargo = self
	snapped_to = cargo_area

	cargo_area.cargo_added()
	
	snapped_to_grid.emit(cargo_area, cargo_area.cargo_grid)
	cargo_area.cargo_added_to_area.emit(cargo_area, self)

func unsnap_from_grid() -> void:
	snapped_out_of_grid.emit(snapped_to, snapped_to.cargo_grid)
	snapped_to.cargo_removed_from_area.emit(snapped_to, self)
	snapped_to.cargo_removed()
	snapped_to.snapped_cargo = null
	snapped_to = null

func find_nearest_cargo_area() -> void:
	var closest_area : CargoArea = null
	var shortest_distance : float = INF

	for area : CargoArea in in_cargo_areas:
		if area != null:
			var distance : float = global_position.distance_to(area.global_position)

			if distance < shortest_distance:
				shortest_distance = distance
				closest_area = area

	nearest_cargo_area = closest_area


func on_interact_self() -> void:
	if snapped_to != null:
		unsnap_from_grid()

	unfreeze()
	unfreeze_in_frame_of_reference()


func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()

	var cargo_unit : CargoUnit = CargoUnit.new()

	box_shape.size = cargo_unit.get_container_size(container_size)

	var collision_shape : CollisionShape3D = CollisionShape3D.new()

	collision_shape.shape = box_shape

	add_child(collision_shape)
