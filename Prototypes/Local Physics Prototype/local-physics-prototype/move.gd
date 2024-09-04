extends RigidBody3D


# Movement speeds
var move_speed: float = 10.0
var rotation_speed: float = 0.05

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Resetting forces for this frame
	var force: Vector3 = Vector3.ZERO
	var torque: Vector3 = Vector3.ZERO

	# Capture input for movement
	if Input.is_action_pressed("move_forward"):
		force -= transform.basis.z * move_speed
	if Input.is_action_pressed("move_backward"):
		force += transform.basis.z * move_speed
	if Input.is_action_pressed("move_left"):
		force -= transform.basis.x * move_speed
	if Input.is_action_pressed("move_right"):
		force += transform.basis.x * move_speed
	if Input.is_action_pressed("move_up"):
		force += transform.basis.y * move_speed
	if Input.is_action_pressed("move_down"):
		force -= transform.basis.y * move_speed

	# Capture input for rotation
	if Input.is_action_pressed("rotate_left"):
		torque += Vector3.UP * rotation_speed
	if Input.is_action_pressed("rotate_right"):
		torque -= Vector3.UP * rotation_speed

	# Apply forces and torques to the rigid body
	apply_central_force(force)
	apply_torque_impulse(torque)
