extends RigidBody3D

@export var move_force: float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_vector = Vector3.ZERO

	# Check for input and set the direction
	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	
	if Input.is_key_pressed(KEY_Y):
		input_vector.y += 1
	if Input.is_key_pressed(KEY_C):
		input_vector.y -= 1


	# Normalize the vector to ensure consistent force application
	input_vector = input_vector.normalized()

	# Apply the force based on the input vector
	if input_vector != Vector3.ZERO:
		apply_central_force(input_vector * move_force)
		apply_torque(Vector3(0, 0, input_vector.y / 2))
