extends Node3D

class_name ModuleSlot

signal module_inserted(module : Module)
signal module_removed(module : Module)

@export
var vehicle : Vehicle

func _module_slot_ready() -> void:
	pass

func _module_slot_process() -> void:
	pass
