extends RigidBody3D

@export
var parent : RigidBody3D 

@export
var move_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("Distance to parent: " + str((parent.position - position).length()))
	
	
	pass
	
func _physics_process(delta: float) -> void:
	var input_vector = Vector3.ZERO
	
	input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_vector.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	# Normalize the input vector to ensure uniform speed in all directions
	input_vector = input_vector.normalized()

	# Apply movement force
	var movement_force = input_vector * move_speed
	#apply_central_force(movement_force)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if parent:
		state.transform.origin += parent.linear_velocity * state.step
		
		var input_vector = Vector3.ZERO
		input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		input_vector.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		input_vector = input_vector.normalized()
		var movement_force = input_vector * transform.basis * move_speed

		state.linear_velocity += movement_force * state.step
		
