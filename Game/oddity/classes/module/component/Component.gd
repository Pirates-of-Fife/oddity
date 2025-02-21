extends Module

class_name Component

@export
var size : ModuleSize.ComponentSize

@export
var initialize_collision_shape_automatically : bool = true

func _ready() -> void:
	_component_ready()

func _component_ready() -> void:
	_module_ready()

	if initialize_collision_shape_automatically:
		_initialize_collision_shape()

func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()

	var module_size : ModuleSize = ModuleSize.new()

	box_shape.size = module_size.get_component_size(size)

	var collision_shape : CollisionShape3D = CollisionShape3D.new()

	collision_shape.shape = box_shape

	add_child(collision_shape)
