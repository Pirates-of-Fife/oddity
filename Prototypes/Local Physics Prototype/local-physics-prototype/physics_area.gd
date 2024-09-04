extends Area3D

var bodies = Array()

var last_pos = Vector3.ZERO
var movement_delta = Vector3.ZERO

var last_vel = Vector3.ZERO
var velocity_delta = Vector3.ZERO

var velocity : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = global_position
	last_vel = velocity

func _physics_process(delta: float) -> void:
	movement_delta = global_position - last_pos
	last_pos = global_position
	
	velocity = movement_delta / delta
	
	velocity_delta = velocity - last_vel
	last_vel = velocity

	for b : RigidBody3D in bodies:
		b.global_position += movement_delta
	

func _on_body_entered(body: Node3D) -> void:
	bodies.append(body)

func _on_body_exited(body: Node3D) -> void:
	bodies.remove_at(bodies.find(body))
