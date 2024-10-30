extends RigidBody3D

@export
var move_speed = 1

@export
var remote_transform : RemoteTransform3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_vector = Vector3.ZERO
	
	input_vector.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	input_vector.z = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))

	# Normalize the input vector to ensure uniform speed in all directions
	input_vector = input_vector.normalized()

	# Apply movement force
	var movement_force = input_vector * move_speed
	apply_central_force(movement_force)
	
	apply_torque(Vector3(0, 0, 2 * delta))
	
	if (Input.is_key_pressed(KEY_B)):
		if (remote_transform.update_position == false):
			remote_transform.update_position = true;
			remote_transform.update_rotation = true;
		else:
			remote_transform.update_position = false;
			remote_transform.update_rotation = false;
