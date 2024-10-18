extends ModuleSlot

class_name StaticModuleSlot

@export
var module : StaticModule

func _ready() -> void:
	_default_ready()

func _module_fits(module : StaticModule) -> bool:
	return false
