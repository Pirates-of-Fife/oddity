extends StaticGameEntity

class_name StaticModule

@export
var module_slot : StaticModuleSlot

var is_being_held_after_uninsert : bool  = false

func _ready() -> void:
	if module_slot != null:
		insert(module_slot)

func insert(slot : StaticModuleSlot) -> void:
	module_slot = slot

	global_position = module_slot.global_position
	global_rotation = module_slot.global_rotation
	module_slot.module = self

	if get_parent_node_3d() != module_slot:
		reparent.call_deferred(module_slot)

func uninsert() -> void:
	module_slot.module = null
	module_slot = null
	reparent.call_deferred(get_tree().get_first_node_in_group("StarSystem"))
