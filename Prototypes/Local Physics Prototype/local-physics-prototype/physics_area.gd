extends Area3D

@export
var parent : RigidBody3D

var bodies = Array()

var last_pos = Vector3.ZERO
var movement_delta = Vector3.ZERO

var last_vel = Vector3.ZERO
var velocity_delta = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_pos = global_position
	last_vel = parent.linear_velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print(bodies)
	#print(movement_delta)
	#print(velocity_delta)
	#print(last_vel)

func _physics_process(delta: float) -> void:
	movement_delta = global_position - last_pos
	last_pos = global_position
	
	velocity_delta = parent.linear_velocity - last_vel
	last_vel = parent.linear_velocity

	for b : RigidBody3D in bodies:
		b.global_position += movement_delta
		
		b.probe.global_position = b.global_position
		
		print(b.probe.global_position - parent.global_position)
		
		var force = velocity_delta * b.mass
		
		PhysicsServer3D.body_apply_central_force(b.get_rid(), force)
	
	#print(global_position)

func _on_body_entered(body: Node3D) -> void:
	#print(body)
	bodies.append(body)
	
	var probe = preload("res://PhysicsBodyProbe.tscn").instantiate()
	
	add_child(probe)
	
	body.probe = probe


func _on_body_exited(body: Node3D) -> void:
	#print(body)
	bodies.remove_at(bodies.find(body))
	
	remove_child(body.probe)
