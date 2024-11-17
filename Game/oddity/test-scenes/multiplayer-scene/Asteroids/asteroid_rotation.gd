extends Node3D

# Variable to store the final rotation vector
var final_rotation: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var rotation_direction: Vector3 = Vector3(
		rng.randf_range(-1.0, 1.0),
		rng.randf_range(-1.0, 1.0),
		rng.randf_range(-1.0, 1.0)
	).normalized()
	var rotation_speed: float = rng.randf_range(0.1, 1.5)
	
	final_rotation = rotation_direction * rotation_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(1, 0, 0), final_rotation.x * delta)
	rotate(Vector3(0, 1, 0), final_rotation.y * delta)
	rotate(Vector3(0, 0, 1), final_rotation.z * delta)
