extends Resource

class_name StarshipLoadout

@export
var module_slots : Array = Array()

func get_module_by_id(id : int) -> PackedScene:
	for slot : ModuleSlotLoadoutResource in module_slots:
		if slot.id == id:
			return slot.module
	
	return null
