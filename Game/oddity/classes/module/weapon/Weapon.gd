extends Module

class_name Weapon

@export_category("Size")

@export
var size : ModuleSize.HardpointSize

@export_category("Weapon")

@export
var nozzle : Marker3D

signal weapon_shot
signal weapon_stopped_shooting
signal weapon_hit(target : GameEntity)

func _ready() -> void:
	_weapon_ready()
	
func _weapon_ready() -> void:
	_module_ready()
	
func shoot() -> void:
	pass

func stop_shooting() -> void:
	pass

func on_hit(game_entity : GameEntity) -> void:
	pass
