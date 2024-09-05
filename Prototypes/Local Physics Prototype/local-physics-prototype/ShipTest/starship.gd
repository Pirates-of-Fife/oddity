extends RigidBody3D

# Variables for thrust and rotation speed
var thrust_force: float = 100000000.0
var torque_force: float = 100000.0
var max_speed: float = 50.0

var in_control : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_released("switch")):
		if (in_control == false):
			in_control = true
			print("shuo" + str(in_control))
		else:
			in_control = false
			
	if (!in_control):
		return
		
		
	_handle_input(delta)

# Handles input and applies force and torque to the ship.
func _handle_input(delta: float) -> void:
	print("sip input")
	# Initialize force and torque vectors
	var thrust = Vector3.ZERO
	var torque = Vector3.ZERO

	# Thrust controls
	if Input.is_action_pressed("move_forward"): # W
		thrust += transform.basis.z * -thrust_force
	if Input.is_action_pressed("move_backward"): # S
		thrust += transform.basis.z * thrust_force
	if Input.is_action_pressed("move_left"): # A
		thrust += transform.basis.x * -thrust_force
	if Input.is_action_pressed("move_right"): # D
		thrust += transform.basis.x * thrust_force
	if Input.is_action_pressed("move_up"): # Space
		thrust += transform.basis.y * thrust_force
	if Input.is_action_pressed("move_down"): # Shift
		thrust += transform.basis.y * -thrust_force

	# Rotation controls (pitch, yaw, roll)
	if Input.is_action_pressed("ui_up"): # Up arrow
		torque += transform.basis.x * -torque_force
	if Input.is_action_pressed("ui_down"): # Down arrow
		torque += transform.basis.x * torque_force
	if Input.is_action_pressed("ui_left"): # Left arrow
		torque += transform.basis.y * -torque_force
	if Input.is_action_pressed("ui_right"): # Right arrow
		torque += transform.basis.y * torque_force
	if Input.is_action_pressed("rotate_left"): # Q
		torque += transform.basis.z * torque_force
	if Input.is_action_pressed("rotate_right"): # E
		torque += transform.basis.z * -torque_force

	# Apply the forces and torques to the RigidBody
	if thrust.length() > 0:
		apply_central_force(thrust)
	if torque.length() > 0:
		apply_torque_impulse(torque)

	# Limit velocity to prevent the ship from going too fast
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
