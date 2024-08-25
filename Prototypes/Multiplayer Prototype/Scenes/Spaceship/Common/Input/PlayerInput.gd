extends "res://Scenes/Spaceship/Common/Interfaces/I_PoweredComponent.gd"

@export_category("Throttle")

@export_range(0, 10)
var throttle_sensitivity : float

@export_range(0, 1)
var throttle_deadzone : float

@export
var is_throttle_axis : bool

@export_category("Mouse")

@export
var mouse_sensitivity : float

@export
var mouse_sensitivity_curve : Curve

@export
var use_mouse_curve : bool

@export
var use_mouse_for_movement : bool

var mouse_pitch : float
var mouse_yaw : float

var movement_vector : Vector3
var rotation_vector : Vector3

signal send_movement_vector(movement_vector)
signal send_rotation_vector(rotation_vector)

var sync : MultiplayerSynchronizer

@export
var cam : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	power_priority = 10
	sync = get_parent().get_parent().get_node("MultiplayerSynchronizer") 
	
	sync.set_multiplayer_authority(str(get_parent().get_parent().name).to_int())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (sync.get_multiplayer_authority() != multiplayer.get_unique_id()):
		return
	
	cam.current = true
		
	movement_vector.x = 0
	movement_vector.y = 0
	rotation_vector.z = 0

	mouse_yaw = clamp(mouse_yaw, -1, 1)
	mouse_pitch = clamp(mouse_pitch, -1, 1)

	## Throttle
	
	if (is_throttle_axis):
		movement_vector.z = Input.get_axis("throttle-forwards", "throttle-backwards")
	else:
		if (Input.is_action_pressed("throttle-forwards")):
			movement_vector.z -= throttle_sensitivity * delta
		
		if (Input.is_action_pressed("throttle-backwards")):
			movement_vector.z += throttle_sensitivity * delta
	
	movement_vector.z = clamp(movement_vector.z, -1, 1)
	
	if (abs(movement_vector.z) < throttle_deadzone and movement_vector.z != 0):
		if ($ThrottleDeadzoneTimer.is_stopped()):
			$ThrottleDeadzoneTimer.start()
	
	## Left - Right
	
	movement_vector.x = Input.get_axis("move-left", "move-right")
	
	## Up - Down
	
	movement_vector.y = Input.get_axis("move-down", "move-up")
		
	## Roll
	
	rotation_vector.z = Input.get_axis("roll-left", "roll-right")

	## Yaw
	
	if (use_mouse_for_movement):
		rotation_vector.y = clamp(mouse_yaw, -1, 1)
		
		rotation_vector.y = rotation_vector.y * mouse_sensitivity_curve.sample(abs(rotation_vector.y)) 
	else:
		rotation_vector.y = Input.get_axis("yaw-left", "yaw-right")

	## Pitch
	
	if (use_mouse_for_movement):
		rotation_vector.x = clamp(mouse_pitch, -1, 1)
		rotation_vector.x = rotation_vector.x * mouse_sensitivity_curve.sample(abs(rotation_vector.x)) 
	else:
		rotation_vector.x = Input.get_axis("pitch-up", "pitch-down")
	
	if %CameraPivots.is_look_around_on and use_mouse_for_movement:
		rotation_vector = Vector3.ZERO
		mouse_yaw = 0
		mouse_pitch = 0
	
	send_movement_vector.emit(movement_vector)
	send_rotation_vector.emit(rotation_vector)
	
	
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_yaw += lerp(0,1,clamp(event.relative.x * get_process_delta_time(),-1,1)) * mouse_sensitivity
		mouse_pitch += lerp(0,1,clamp(event.relative.y * get_process_delta_time(),-1,1)) * mouse_sensitivity


func _on_throttle_deadzone_timer_timeout():
	if (abs(movement_vector.z) < throttle_deadzone):
		movement_vector.z = 0

func recieve_power(power : float):
	recieved_power = power
