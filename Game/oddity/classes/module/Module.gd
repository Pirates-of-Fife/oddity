extends GameEntity

class_name Module

@export
var module_slot : ModuleSlot


func insert(slot : ModuleSlot) -> void:
	global_position = slot.global_position
	global_rotation = slot.global_rotation
	module_slot = slot
	slot.module = self
	
	freeze_static()
	
func uninsert() -> void:
	module_slot = null
	module_slot.module = null
	unfreeze()

	
func _process(delta: float) -> void:
	pass
	
	

	
