extends Node3D

class_name ModuleSlot

signal module_inserted(module : Module)
signal module_removed(module : Module)

@export
var vehicle : Starship


## Used for loadouts
@export
var id : int = 0

func _ready() -> void:
	_module_slot_ready()

func _module_slot_ready() -> void:
	pass

func _module_slot_process() -> void:
	pass
