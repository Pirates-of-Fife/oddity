extends GameEntity

class_name CargoContainer

@export_category("Cargo")

@export
var container_size : CargoUnit.ContainerSize


# INFO Will be replaced by a resource file or something else
@export
var contents : String

func _ready() -> void:
	_cargo_container_ready()

func _cargo_container_ready() -> void:
	_default_ready()
	_initialize_collision_shape()

func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()

	var cargo_unit : CargoUnit = CargoUnit.new()

	box_shape.size = cargo_unit.get_container_size(container_size)

	var collision_shape : CollisionShape3D = CollisionShape3D.new()

	collision_shape.shape = box_shape

	add_child(collision_shape)
