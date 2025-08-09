extends Module

class_name AbyssalJumpDrive

@export
var size : ModuleSize.AbyssalJumpDriveSize

@export
var initialize_collision_shape_automatically : bool = true

@export
var fuel_per_jump : float = 1000

func _ready() -> void:
	_abyssal_jump_drive_ready()

func _abyssal_jump_drive_ready() -> void:
	_module_ready()
	
	if initialize_collision_shape_automatically:
		_initialize_collision_shape()
	
func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()
	
	var module_size : ModuleSize = ModuleSize.new()
	
	box_shape.size = module_size.get_abyssal_jump_drive_size(size)
	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	
	collision_shape.shape = box_shape
		
	add_child(collision_shape)
