extends Resource

class_name StarshipLoadout

@export
var module_slots : Array[ModuleSlotLoadoutResource] = Array()

@export
var cargo : Array[CargoContainerLoadoutResource] = Array()

@export
var entities : Array[GameEntityLoadoutResource] = Array()

@export
var ship_name : StringName

@export
var ship_identification : StringName

@export
var value : int = 0

@export
var apply_health : bool = false

@export
var current_health : float

## not implemented yet
@export
var ship_color : Color

@export
var current_ammo : float = 10000

@export
var max_ammo : float = 10000

@export
var current_heat : float = 0

@export
var current_fuel : float = 10800

@export
var max_fuel : float = 10800

func get_module_by_id(id : int) -> PackedScene:
	for slot : ModuleSlotLoadoutResource in module_slots:
		if slot.id == id:
			return slot.module
	
	return null

func get_entry_by_id(id : int) -> ModuleSlotLoadoutResource:
	for slot : ModuleSlotLoadoutResource in module_slots:
		if slot.id == id:
			return slot
	
	return null
