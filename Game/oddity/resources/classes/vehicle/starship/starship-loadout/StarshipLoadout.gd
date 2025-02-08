extends Resource

class_name StarshipLoadout

@export
var module_slots : Array = Array()

@export
var cargo : Array = Array()

@export
var entities : Array = Array()

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

func get_module_by_id(id : int) -> PackedScene:
	for slot : ModuleSlotLoadoutResource in module_slots:
		if slot.id == id:
			return slot.module
	
	return null
