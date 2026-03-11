extends Node3D

class_name Mind

signal posses(control_entity : ControlEntity)

@export_category("Control Entity")
@export
var control_entity : ControlEntity

var current_controller : Controller

func _ready() -> void:
	_mind_ready()

func _mind_ready() -> void:
	if (control_entity != null):
		possess(control_entity)

func _physics_process(delta: float) -> void:
	self.global_position = control_entity.anchor.camera_anchor.global_position
	self.global_rotation = control_entity.anchor.camera_anchor.global_rotation

func die() -> void:
	pass

func possess(control_entity : ControlEntity) -> void:
	if control_entity.player != null:
		return
	
	if current_controller != null:
		current_controller.queue_free()
	
	var controller_script : PackedScene

	if self is Player:
		controller_script = load(control_entity.controller_reference)
	elif self is Ai:
		controller_script = load(control_entity.ai_controller_reference)

	var controller_instance : Controller = controller_script.instantiate()
	controller_instance.control_entity = control_entity
	add_child(controller_instance)

	current_controller = controller_instance

	self.control_entity.player = null
	self.control_entity = control_entity
	self.control_entity.player = self

	reparent.call_deferred(control_entity.anchor.camera_anchor)

	posses.emit(self.control_entity)
	
	var target_anchor : Node3D = self.control_entity.anchor.camera_anchor

	var tween : Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"global_position",
		target_anchor.global_position,
		0.4
	)

	tween.tween_property(
		self,
		"global_rotation",
		target_anchor.global_rotation,
		0.4
	)
