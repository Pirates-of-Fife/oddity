extends ModuleSlot

class_name StaticModuleSlot

@export
var module : StaticModule

func _ready() -> void:
	_static_module_slot_ready()

func _static_module_slot_ready() -> void:
	_module_slot_ready()

func _module_fits(module : StaticModule) -> bool:
	return false
