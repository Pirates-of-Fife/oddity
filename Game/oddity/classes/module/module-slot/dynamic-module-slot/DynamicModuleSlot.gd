@tool
extends ModuleSlot

class_name DynamicModuleSlot

@export
var module : Module

var module_held_in_slot : Module

@export
var initialize_area_automatically : bool = true

@export
var highlight_box : Node3D

@export
var area_root : Node3D

@export
var initialize_area_in_editor : bool :
	set(value):
		_initialize_area()

func _ready() -> void:
	_dynamic_module_slot_ready()

func _dynamic_module_slot_ready() -> void:
	_module_slot_ready()

	if initialize_area_automatically:
		_initialize_area()

func _process(delta: float) -> void:
	_dynamic_module_slot_process(delta)



func _dynamic_module_slot_process(delta : float) -> void:
	_module_slot_process()

	if Engine.is_editor_hint():
		return

	if module_held_in_slot == null:
		if highlight_box != null:
			highlight_box.hide()
		return

	if module_held_in_slot.is_being_held:
		if highlight_box != null:
			highlight_box.show()
	else:
		highlight_box.hide()

	if !module_held_in_slot.is_being_held:
		if module_held_in_slot.module_slot == null:
			module_held_in_slot.insert(self)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Module:
		if _module_fits(body) == true:
			module_held_in_slot = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Module:
		if body == module_held_in_slot:
			module_held_in_slot = null


func _module_fits(module : Module) -> bool:
	return false

func _initialize_area() -> void:
	pass
