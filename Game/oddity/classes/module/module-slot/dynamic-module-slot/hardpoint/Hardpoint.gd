extends DynamicModuleSlot

class_name Hardpoint

@export
var size : ModuleSize.HardpointSize

func _module_fits(module : Module) -> bool:
	if module is Weapon:
		if module.size == size:
			return true
	return false
