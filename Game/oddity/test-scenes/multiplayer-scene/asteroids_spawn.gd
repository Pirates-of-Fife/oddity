@tool
extends Node3D

class_name AsteroidsSpawn

# Exports for asteroid scenes
@export var asteroid_1: PackedScene
@export var asteroid_2: PackedScene
@export var asteroid_3: PackedScene
@export var asteroid_4: PackedScene
@export var asteroid_5: PackedScene

# Configuration options
@export var asteroid_count: int = 100
@export var spawn_radius_min: float = 1000.0
@export var spawn_radius_max: float = 5000.0
@export var random_seed: int = 0

@export
var generate : bool :
	set(value):
		if value == true:
			generate_asteroids()

var asteroids: Array = [] # Array of packed scenes
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	# Prepare the asteroid array
	asteroids = [
		asteroid_1,
		asteroid_2,
		asteroid_3,
		asteroid_4,
		asteroid_5
	]
	
	# Set random seed
	rng.seed = random_seed
	
	generate_asteroids()


func generate_asteroids() -> void:
	# Clear previous asteroids
	for child : Node3D in get_children():
		if child.name.begins_with("Asteroid_"):
			child.queue_free()

	# Place asteroids
	for i : int in range(asteroid_count):
		_spawn_asteroid(i)

func _spawn_asteroid(index: int) -> void:
	# Pick a random asteroid scene
	var asteroid_scene: PackedScene = asteroids[rng.randi_range(0, asteroids.size() - 1)]
	if asteroid_scene == null:
		return
	
	# Instance the asteroid
	var asteroid_instance: Node3D = asteroid_scene.instantiate() as Node3D
	asteroid_instance.name = "Asteroid_%d" % index
	
	# Determine position
	var distance: float = rng.randf_range(spawn_radius_min, spawn_radius_max)
	var angle1: float = rng.randf_range(0, TAU)
	var angle2: float = rng.randf_range(-PI / 2, PI / 2)
	var position: Vector3 = Vector3(
		distance * cos(angle1) * cos(angle2),
		distance * sin(angle2),
		distance * sin(angle1) * cos(angle2)
	)
	asteroid_instance.global_position = position
	
	# Set random scale with distribution
	var scale: float = _random_scale()
	asteroid_instance.scale = Vector3.ONE * scale
	
	# Add asteroid to the scene
	add_child(asteroid_instance)

func _random_scale() -> float:
	# Random scale with weighted distribution
	if rng.randf() <= 0.8:
		return rng.randf_range(30.0, 70.0)
	else:
		return rng.randf_range(1.0, 100.0)
