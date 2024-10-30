extends Node3D

class_name Player

@export_category("Control Entity")
@export
var control_entity : ControlEntity

var current_controller : Controller

func _ready() -> void:
	if (control_entity != null):
		possess(control_entity)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if control_entity == null:
		return
	
	self.global_position = control_entity.anchor.camera_anchor.global_position
	self.global_rotation = control_entity.anchor.camera_anchor.global_rotation

func possess(control_entity : ControlEntity) -> void:
	if current_controller != null:
		current_controller.queue_free()
	
	var controller_script : PackedScene = load(control_entity.controller_reference) 
	
	var controller_instance : Controller = controller_script.instantiate()
	controller_instance.control_entity = control_entity
	add_child(controller_instance)
	
	current_controller = controller_instance
	
	self.control_entity.player = null
	self.control_entity = control_entity
	self.control_entity.player = self
	
