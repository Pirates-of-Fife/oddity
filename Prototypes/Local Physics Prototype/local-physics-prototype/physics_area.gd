extends Area3D

var bodies = Array()

var last_pos = Vector3.ZERO
var movement_delta = Vector3.ZERO

var last_rot : Quaternion
var rotation_delta : Quaternion

var last_vel = Vector3.ZERO
var velocity_delta = Vector3.ZERO

var velocity : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = global_position
	last_vel = velocity
	last_rot = global_basis.get_rotation_quaternion().normalized()

func _physics_process(delta: float) -> void:
	calculate_velocity(delta)
	process_movement_delta()
	process_rotation_delta()
	process_velocity_delta()
	
	gravity_direction = -global_transform.basis.y

	for b : RigidBody3D in bodies:	
		move_rigidbody(b)


func vector_origin_body(body : RigidBody3D) -> Vector3:
	return body.global_position - global_position

func move_rigidbody(body : RigidBody3D):
	var v : Vector3 = vector_origin_body(body)
	#var r : Quaternion = rotation_delta.normalized()
	
	var newVec : Vector3 = rotation_delta.normalized() * v
	
	
	#print(str(v) + " to " + str(newVec))
	
	var newPos : Vector3 = global_position + newVec
	
	
	
	$Rotation.global_position = newPos
	
	#print(newPos)
	
	var deltaVec = newPos - body.global_position
	
	#print(deltaVec)
	
	body.global_position += movement_delta + deltaVec
	
	var delta_euler = rotation_delta.get_euler()

	var new_transform = body.global_transform
	new_transform.basis = Basis(rotation_delta) * new_transform.basis
	body.global_transform = new_transform
	#print(global_position - body.global_position)
	
	#var basis_from_quaternion = Basis(rotation_delta)
	
	#print(basis_from_quaternion)


	#body.global_rotation += delta_euler

	#body.rotation = body.rotation + delta_euler

	# Apply torque impulse based on the delta rotation
	#var d = body.angular_damp
	#body.angular_damp = 100000
	#body.apply_torque_impulse(delta_euler * body.mass) # Multiplied to scale the torque impulse
	#body.angular_damp = d
	#body.global_position += deltaVec
	#body.global_rotation += rotation_delta

func process_movement_delta():
	movement_delta = global_position - last_pos
	last_pos = global_position
	
func process_rotation_delta():
	rotation_delta = global_basis.get_rotation_quaternion() * last_rot.inverse()
	last_rot = global_basis.get_rotation_quaternion()
	
	#print(rotation_delta)

func calculate_velocity(delta : float):
	velocity = movement_delta / delta
	
func process_velocity_delta():
	velocity_delta = velocity - last_vel
	last_vel = velocity

func _on_body_entered(body: Node3D) -> void:
	bodies.append(body)

func _on_body_exited(body: Node3D) -> void:
	bodies.remove_at(bodies.find(body))
