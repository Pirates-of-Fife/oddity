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

## not implemented yet
@export
var ship_color : Color

func get_module_by_id(id : int) -> PackedScene:
	for slot : ModuleSlotLoadoutResource in module_slots:
		if slot.id == id:
			return slot.module
	
	return null
