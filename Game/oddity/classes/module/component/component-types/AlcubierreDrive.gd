extends Module

class_name AlcubierreDrive

@export
var size : ModuleSize.AlcubierreDriveSize

@export
var initialize_collision_shape_automatically : bool = true

func _ready() -> void:
	_alcubierre_drive_ready()

func _alcubierre_drive_ready() -> void:
	_module_ready()
	
	if initialize_collision_shape_automatically:
		_initialize_collision_shape()
	
func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()
	
	var module_size : ModuleSize = ModuleSize.new()
	
	box_shape.size = module_size.get_alcubierre_drive_size(size)
	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	
	collision_shape.shape = box_shape
		
	add_child(collision_shape)
