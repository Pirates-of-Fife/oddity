extends Node3D

var final_rotation : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var rotation_direction = Vector3(rng.randf_range(-1, 1), rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	var rotation_speed = rng.randf_range(0.1, 1.5)
	
	
	final_rotation = rotation_direction * rotation_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3(1, 0, 0), final_rotation.x * delta)
	rotate(Vector3(0, 1, 0), final_rotation.y * delta)
	rotate(Vector3(0, 0, 1), final_rotation.z * delta)
