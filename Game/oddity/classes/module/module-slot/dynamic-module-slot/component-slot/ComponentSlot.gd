extends DynamicModuleSlot

class_name ComponentSlot

@export
var size : ModuleSize.ComponentSize

func _module_fits(module : Module) -> bool:
	if module is Component:
		if module.size == size:
			return true
	return false
