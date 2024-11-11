extends DynamicModuleSlot

class_name ExteriorModuleSlot

func _module_fits(module : Module) -> bool:
	if module is ExteriorModule:
			return true
	return false

func _default_ready() -> void:
	add_to_group("ExteriorModuleSlot")
