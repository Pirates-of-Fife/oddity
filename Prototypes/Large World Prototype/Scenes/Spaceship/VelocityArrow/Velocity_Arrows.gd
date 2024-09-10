extends Node3D

@export
var rigid_body: RigidBody3D

@export
var z: MeshInstance3D

@export
var x: MeshInstance3D

@export
var y: MeshInstance3D

@export
var global: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global:
		#look_at(Vector3(0, 0, 1000000000))	
		
		z.scale.z = rigid_body.linear_velocity.z
		z.position.z = rigid_body.linear_velocity.z / 2.0

		x.scale.x = rigid_body.linear_velocity.x
		x.position.x = rigid_body.linear_velocity.x / 2.0

		y.scale.y = rigid_body.linear_velocity.y
		y.position.y = rigid_body.linear_velocity.y / 2.0
	else:
		var b = rigid_body.transform.basis
		var v_len = rigid_body.linear_velocity.length()
		var v_nor = rigid_body.linear_velocity.normalized()
		
		var vel : Vector3
		vel.x = b.x.dot(v_nor) * v_len
		vel.y = b.y.dot(v_nor) * v_len
		vel.z = b.z.dot(v_nor) * v_len
		
		vel = rigid_body.velocity
		
		z.scale.z = vel.z
		z.position.z = vel.z / 2.0

		x.scale.x = vel.x
		x.position.x = vel.x / 2.0

		y.scale.y = vel.y
		y.position.y = vel.y / 2.0
