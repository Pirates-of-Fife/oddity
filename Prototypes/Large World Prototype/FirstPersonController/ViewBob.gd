extends Node3D

@export
var enable : bool

@export_category("View Bob Parameters")

@export
var amplitude : float = 0.0166

@export
var frequency : float = 50

@export
var toggle_speed : float = 1.0

@export_category("Reference Nodes")

@export
var camera : Camera3D

@export
var player : CharacterBody3D

var start_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = camera.position
	reset_position()
	
func _process(delta):
	if (!enable):
		return
	
	if check_motion():
		view_bob()
	
	reset_position()

func view_bob():
	var speed = Vector3(player.velocity.x, 0, player.velocity.z).length()
	
	var motion_y : float = (sin(Time.get_ticks_msec() / frequency)) * amplitude * speed
	var motion_x : float = (cos(Time.get_ticks_msec() / frequency * 2)) * amplitude * 0.15 * speed

	camera.position.y = motion_y
	camera.position.x = motion_x
	
func check_motion() -> bool:
	var speed = Vector3(player.velocity.x, 0, player.velocity.z).length()
	
	if (speed < toggle_speed):
		return false
	
	if (!player.is_on_floor()):
		return false
	
	return true

func reset_position() -> void:
	if (camera.position == start_pos):
		return
		
	camera.position = lerp(camera.position, start_pos, 1 * get_process_delta_time())
