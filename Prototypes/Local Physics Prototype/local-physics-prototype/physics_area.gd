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

	#print("======== " + str(self))
	#for b : RigidBody3D in bodies:
	#	print(str(b) + "is frozen? " + str(b.freeze))
	#print("========")

	for b : RigidBody3D in bodies:
		#if (b is CharacterBody3D):
		#	b.up_direction = global_transform.basis.y
		#	return
		
		#if (b.freeze == true):
		#print(body)
		
			#if (b.get_parent_node_3d() != self):
			#	b.reparent(self)
			#print("reparented frozen " + str(body))
			#else:
			#	if (b.get_parent_node_3d() == self):
			#		b.reparent(get_parent_node_3d().get_parent_node_3d())
			#		print("reparented unfrozen " + str(b))

		
		if (b.freeze != true):
			move_rigidbody(b)


func vector_origin_body(body) -> Vector3:
	return body.global_position - global_position

func move_rigidbody(body):
	var v : Vector3 = vector_origin_body(body)
		
	var newVec : Vector3 = rotation_delta.normalized() * v
		
	var newPos : Vector3 = global_position + newVec
	
	var deltaVec = newPos - body.global_position
	
	body.global_position += movement_delta + deltaVec
	
	var delta_euler = rotation_delta.get_euler()

	var new_transform = body.global_transform
	new_transform.basis = Basis(rotation_delta) * new_transform.basis
	body.global_transform = new_transform


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
	#print("BODY ENTERED " + str(body) + " " + str(body.freeze) + " " + str(bodies))

	bodies.append(body)
	#print("added " + str(body) + " to bodies")

	#if (body.get_parent_node_3d() == self):
		#body.reparent(get_parent_node_3d().get_parent_node_3d())

	#if (body.freeze == false):
	#	if (body.get_parent_node_3d() == self):
	#		body.reparent(get_parent_node_3d().get_parent_node_3d())
			#print(str(body.get_parent_node_3d()) + " " + str(body))
		
	#print("ENTER: " + str(body))
	#body.reparent(self)
	

		#if (body.get_parent_node_3d() == self):
			#body.reparent(get_parent_node_3d().get_parent_node_3d())
			#print("reparented unfrozen " + str(body))

	
func _on_body_exited(body: Node3D) -> void:
	#print("EXIT BODY " + str(body) + " " + str(bodies))
	
	bodies.remove_at(bodies.find(body))
	#print("Removed " + str(body) + " from bodies")
	
	#if (body.freeze == true):
	#	if (body.get_parent_node_3d() != self):
	#		body.reparent(self)
			#print(str(body.get_parent_node_3d()) + " " + str(body))

			#print("reparented frozen " + str(body))
	#else:
		#if (body.get_parent_node_3d() == self):
			#body.reparent(get_parent_node_3d().get_parent_node_3d())
			#print("reparented unfrozen " + str(body))
	
	#body.reparent(get_parent_node_3d().get_parent_node_3d())


func _on_area_entered(area: Area3D) -> void:
	pass # Replace with function body.


func _on_area_exited(area: Area3D) -> void:
	pass # Replace with function body.
