extends DynamicModuleSlot

class_name AbyssalJumpDriveSlot

@export
var abyssal_jump_drive_size : ModuleSize.AbyssalJumpDriveSize

func _module_fits(module : Module) -> bool:
	if module is AbyssalJumpDrive:
		if module.size == abyssal_jump_drive_size:
			return true
	return false

func _default_ready() -> void:
	add_to_group("ComponentSlot")

func _initialize_area() -> void:
	var area : Area3D = Area3D.new()
	
	area.collision_layer = 524288
	area.collision_mask = 524288
	
	area.monitoring = true
	
	var box_shape : BoxShape3D = BoxShape3D.new()
	
	var module_size : ModuleSize = ModuleSize.new()
	
	box_shape.size = module_size.get_abyssal_jump_drive_size(abyssal_jump_drive_size)
	
	print(abyssal_jump_drive_size)
	print(box_shape.size)

	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	
	collision_shape.shape = box_shape
	
	add_child(area)
	area.add_child(collision_shape)
	
	var error_enter : Error = area.body_entered.connect(_on_area_3d_body_entered)
	var error_exit : Error = area.body_exited.connect(_on_area_3d_body_exited)
	
	if (error_enter != OK):
		printerr("Component Slot area enter failed to connect.")
	if (error_exit != OK):
		printerr("Component Slot area exit failed to connect.")
