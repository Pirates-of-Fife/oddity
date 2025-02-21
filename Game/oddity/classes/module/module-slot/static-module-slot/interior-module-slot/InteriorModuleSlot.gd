extends StaticModuleSlot

class_name InteriorModuleSlot

func _module_fits(module : StaticModule) -> bool:
	if self.module != null:
		return false

	if module is InteriorModule:
			return true
	return false

func _ready() -> void:
	_interior_module_slot_ready()

func _interior_module_slot_ready() -> void:
	_static_module_slot_ready()
	add_to_group("InteriorModuleSlot")
