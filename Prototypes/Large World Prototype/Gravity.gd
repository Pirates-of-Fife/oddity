extends RigidBody3D

@export
var local_gravity : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var gravity_vector = (local_gravity.global_position - global_position) * 5 * mass
	print(gravity_vector)
	
	apply_central_force(gravity_vector)
