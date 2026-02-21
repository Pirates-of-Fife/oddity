extends Resource

class_name StarshipLoadout

@export
var module_slots : Array[ModuleSlotLoadoutResource] = []

@export
var cargo : Array[CargoContainerLoadoutResource] = []

@export
var entities : Array[GameEntityLoadoutResource] = []

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
var current_heat : float = 0

@export
var current_fuel : float = 10800

@export
var landing_gear_on : bool = false

@export_category("Upgrades")

@export_range(0, 5, 1, "suffix:Grade")
var current_health_upgrade : int

@export_range(0, 5, 1, "suffix:Grade")
var current_heat_capacity_upgrade : int

@export_range(0, 5, 1, "suffix:Grade")
var current_fuel_capacity_upgrade : int

@export_range(0, 5, 1, "suffix:Grade")
var current_ammo_capacity_upgrade : int


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
