extends Node3D

class_name Interactable

@export
var ship_scale : bool = false

@export
var prompt_offset : float = 0.1

@export
var prompt_linger_time : float = 1

signal interact

var is_being_looked_at : bool

var timer : Timer = Timer.new()

var camera : Camera3D

@onready
var interaction_prompt = $InteractionPrompt

@export
var interaction_shape : CollisionShape3D

func _ready():
	timer.wait_time = prompt_linger_time
	timer.one_shot = true
	timer.connect("timeout", _on__timer_timeout)
	add_child(timer)
	
	interaction_prompt.ship_scale = ship_scale

func _process(delta):
	if (camera != null):
		interaction_prompt.global_position = calculate_midpoint_with_sideways_offset(interaction_shape.global_position, camera.global_position, prompt_offset)
		interaction_prompt.look_at(camera.global_position)
	
func on_look(camera_looking_at : Camera3D):
	camera = camera_looking_at
	
	is_being_looked_at = true
	
	interaction_prompt.show_prompt()
	
	is_being_looked_at = false
	
	timer.start()
	
func on_interact() -> void:
	interact.emit()

func calculate_midpoint_with_sideways_offset(pos1: Vector3, pos2: Vector3, offset_distance: float) -> Vector3:
	var midpoint = (pos1 + pos2) / 2.0
	var direction = (pos2 - pos1).normalized()
	# Calculate perpendicular vector
	var perpendicular = Vector3(direction.z, 0, -direction.x).normalized()
	var offset = perpendicular * offset_distance
	var offset_position = midpoint + offset
	return offset_position


func _on__timer_timeout():
	if (!is_being_looked_at):
		interaction_prompt.hide_prompt()
