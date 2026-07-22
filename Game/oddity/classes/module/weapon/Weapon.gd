extends Module

class_name Weapon

@export_category("Size")

@export
var size : ModuleSize.HardpointSize

@export_category("Weapon")

@export
var nozzle : Marker3D

var aim_point : Vector3
var aim_assist : float

signal weapon_shot
signal weapon_stopped_shooting
signal weapon_hit(target : GameEntity)

func _ready() -> void:
	_weapon_ready()
	
func _weapon_ready() -> void:
	_module_ready()
	
	inserted.connect(_on_weapon_inserted)
	
	can_be_picked_up = true

func _on_weapon_inserted(slot : ModuleSlot) -> void:
	if slot is Hardpoint:
		if slot.size == ModuleSize.HardpointSize.SIZE_6 and size == ModuleSize.HardpointSize.SIZE_5:
			global_position.z = slot.global_position.z + -0.336
			global_position.y = slot.global_position.y + -0.268	
	
func shoot() -> void:
	pass

func stop_shooting() -> void:
	pass

func on_hit(game_entity : GameEntity) -> void:
	pass
