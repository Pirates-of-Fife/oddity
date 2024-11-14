extends DynamicModuleSlot

class_name RadiatorSlot

@export
var size : ModuleSize.ComponentSize

func _module_fits(module : Module) -> bool:
	if module is Radiator:
		if module.size == size:
			return true
	return false

func _radiator_slot_ready() -> void:
	initialize_area_automatically = false
	_dynamic_module_slot_ready()
	add_to_group("ComponentSlot")
		
	var area : Area3D = $SlotArea
	
	area.collision_layer = 524288
	area.collision_mask = 524288
		
	var error_enter : Error = area.body_entered.connect(_on_area_3d_body_entered)
	var error_exit : Error = area.body_exited.connect(_on_area_3d_body_exited)
	
	if (error_enter != OK):
		printerr("Component Slot area enter failed to connect.")
	if (error_exit != OK):
		printerr("Component Slot area exit failed to connect.")


func _ready() -> void:
	_radiator_slot_ready()
