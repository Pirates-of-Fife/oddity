extends StaticModuleSlot

class_name InteriorModuleSlot

func _module_fits(module : StaticModule) -> bool:
	if module is InteriorModule:
			return true
	return false
