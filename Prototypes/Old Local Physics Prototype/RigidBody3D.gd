extends RigidBody3D

# Configuration
@export
var use_wasd: bool = true  # Toggle between WASD and Arrow keys
var move_speed: float = 10.0

@export
var follow_parent: bool = true  # Toggle to follow parent or not

# Store the parent Rigidbody3D node
@onready
var parent_body: RigidBody3D = %ParentBody

var initial_offset: Transform3D

var current_offset

var relative_position: Vector3

@export
var can_be_child : bool = false

func _ready():
	# Get the parent Rigidbody3D node
	initial_offset = global_transform.affine_inverse() * parent_body.global_transform
	current_offset = initial_offset
	relative_position = global_transform.origin - parent_body.global_transform.origin

func _process(delta):
	if (Input.is_action_just_released("ui_accept") and can_be_child == true):
		print("switch")
		if (follow_parent == true):
			follow_parent = false
		else:
			follow_parent = true
			initial_offset = global_transform.affine_inverse() * parent_body.global_transform
			current_offset = initial_offsets
			relative_position = global_transform.origin - parent_body.global_transform.origin

	#
	#var input_vector = Vector3.ZERO
#
	#if use_wasd:
		#input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		#input_vector.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	#else:
		#input_vector.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
		#input_vector.z = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
#
	## Normalize the input vector to ensure uniform speed in all directions
	#input_vector = input_vector.normalized()
	#
	## Apply the movement force
	#apply_central_force(input_vector * move_speed)
		
	if (follow_parent):
		print(name)
		return
	
	apply_torque(Vector3(0, 0, 0.5 * delta))
	
	  # Update the current offset based on user input
	#relative_position += input_vector * move_speed * delta




func _integrate_forces(state: PhysicsDirectBodyState3D):


	# Calculate movement based on user input
	var input_vector = Vector3.ZERO
	if use_wasd:
		input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_vector.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	else:
		input_vector.x = int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
		input_vector.z = int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))

	# Normalize the input vector to ensure uniform speed in all directions
	input_vector = input_vector.normalized()

	# Apply movement force
	var movement_force = input_vector * move_speed
	state.apply_central_force(movement_force)

	if (!follow_parent):
		return
		
	# Get the parent's transform
	var parent_transform: Transform3D = parent_body.global_transform

	# Update the relative position
	#relative_position += movement_force * state.step

	# Calculate the new global position based on parent transform and relative position
	var new_global_position: Vector3 = parent_transform.origin + (parent_transform.basis * relative_position)

	# Apply the new global position to the child's transform
	state.transform.origin = new_global_position

	# Apply the parent's rotation to the child (rotation based on initial offset)
	state.transform.basis = parent_transform.basis * initial_offset.basis

	# Preserve the child's velocity and angular velocity
	state.linear_velocity = state.linear_velocity
	state.angular_velocity = state.angular_velocity
