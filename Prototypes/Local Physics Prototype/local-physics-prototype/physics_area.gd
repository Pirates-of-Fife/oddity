extends Area3D

var bodies = Array()

var last_pos = Vector3.ZERO
var movement_delta = Vector3.ZERO

var last_rot
var rotation_delta

var last_vel = Vector3.ZERO
var velocity_delta = Vector3.ZERO

var velocity : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = global_position
	last_vel = velocity
	last_rot = global_rotation

func _physics_process(delta: float) -> void:
	calculate_velocity(delta)
	process_movement_delta()
	process_rotation_delta()
	process_velocity_delta()

	for b : RigidBody3D in bodies:
		move_rigidbody(b)

func move_rigidbody(body : RigidBody3D):
	body.global_position += movement_delta
	#body.global_rotation += rotation_delta

func process_movement_delta():
	movement_delta = global_position - last_pos
	last_pos = global_position
	
func process_rotation_delta():
	rotation_delta = global_rotation - last_rot
	last_rot = global_rotation

func calculate_velocity(delta : float):
	velocity = movement_delta / delta
	
func process_velocity_delta():
	velocity_delta = velocity - last_vel
	last_vel = velocity

func _on_body_entered(body: Node3D) -> void:
	bodies.append(body)

func _on_body_exited(body: Node3D) -> void:
	bodies.remove_at(bodies.find(body))
