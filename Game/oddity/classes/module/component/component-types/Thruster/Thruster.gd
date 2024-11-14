extends Module

class_name Thruster

@export
var size : ModuleSize.ThrusterSize

func _ready() -> void:
	_thruster_ready()

func _thruster_ready() -> void:
	_module_ready()
	
