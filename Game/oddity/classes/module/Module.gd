extends GameEntity

class_name Module

@export
var module_slot : DynamicModuleSlot

var is_being_held_after_uninsert : bool  = false

func _ready() -> void:
	_module_ready()

func _module_ready() -> void:
	_default_ready()
	
	if module_slot != null:
		insert(module_slot)
	
	on_interact.connect(_on_interact)

func insert(slot : DynamicModuleSlot) -> void:
	can_freeze = false
	
	module_slot = slot
	
	freeze_static()
		
	global_position = module_slot.global_position
	global_rotation = module_slot.global_rotation
	module_slot.module = self
	
	if get_parent_node_3d() != module_slot:
		reparent.call_deferred(module_slot)
	
	
func uninsert() -> void:
	module_slot.module = null
	module_slot = null
	reparent.call_deferred(get_tree().get_first_node_in_group("World"))
	can_freeze = true


func _on_interact() -> void:
	unfreeze()
	
	if module_slot != null:
		is_being_held_after_uninsert = true
		uninsert()
