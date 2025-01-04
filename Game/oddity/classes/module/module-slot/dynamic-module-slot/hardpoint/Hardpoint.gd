extends DynamicModuleSlot

class_name Hardpoint

@export
var size : ModuleSize.HardpointSize

func _module_fits(module : Module) -> bool:
	if self.module != null:
		return false

	if module is Weapon:
		if module.size == size:
			return true
	return false

func _default_ready() -> void:
	add_to_group("Hardpoint")
