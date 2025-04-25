extends GameEntity

class_name Module

signal inserted(slot : ModuleSlot)
signal uninserted(slot : ModuleSlot)

@export_category("Module Resource")

@export
var module_resource : ModuleResource


@export_category("Module Slot")
@export
var module_slot : DynamicModuleSlot

@export_category("Heat")

@export
var passive_heat_generation : float

var is_being_held_after_uninsert : bool  = false

func _ready() -> void:
	_module_ready()

func _module_ready() -> void:
	_default_ready()

	if module_slot != null:
		insert(module_slot)

	on_interact.connect(_on_interact)
	inserted.connect(_on_insert)
	uninserted.connect(_on_uninsert)

func _on_insert(slot : ModuleSlot) -> void:
	pass

func _on_uninsert(slot : ModuleSlot) -> void:
	pass

func insert(slot : DynamicModuleSlot) -> void:
	can_freeze = false

	module_slot = slot

	freeze_static()

	global_position = module_slot.global_position
	global_rotation = module_slot.global_rotation
	module_slot.module = self

	if get_parent_node_3d() != module_slot:
		reparent.call_deferred(module_slot)

	module_slot.module_inserted.emit(self)
	inserted.emit(module_slot)


func uninsert() -> void:
	uninserted.emit(module_slot)
	module_slot.module_removed.emit(self)
	module_slot.module = null
	module_slot = null
	reparent.call_deferred(get_tree().get_first_node_in_group("StarSystem"))
	can_freeze = true


func add_heat(heat : float) -> void:
	if (module_slot == null):
		return



	module_slot.add_heat(heat)

func _on_interact() -> void:
	unfreeze()

	if module_slot != null:
		is_being_held_after_uninsert = true
		uninsert()
