extends Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	physics_parent = parent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_vector = Vector3.ZERO
	
	input_vector.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	input_vector.z = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))

	# Normalize the input vector to ensure uniform speed in all directions
	input_vector = input_vector.normalized()

	# Apply movement force
	var movement_force = input_vector * move_speed
	
	applied_force = movement_force
