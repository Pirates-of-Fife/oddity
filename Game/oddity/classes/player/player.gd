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

	if (Input.is_action_just_released("ui_cancel")):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://ui/main-menu/MainMenu.tscn")

	if control_entity == null:
		return

func _physics_process(delta: float) -> void:
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
	
	reparent.call_deferred(control_entity.anchor.camera_anchor)
	
	self.position = self.control_entity.anchor.camera_anchor.global_position
	self.rotation = self.control_entity.anchor.camera_anchor.global_rotation
	
	if control_entity is Starship:
		save_last_possessed_starship(control_entity)

func save_last_possessed_starship(starship : Starship) -> void:
	var save_data : Dictionary = {}
	save_data["scene_path"] = starship.scene_file_path  # Store scene path, or use a unique ID if preferred

	var save_file : FileAccess = FileAccess.open("user://last_possessed_starship.save", FileAccess.WRITE)

	if save_file:
		save_file.store_var(save_data)
		save_file.close()
