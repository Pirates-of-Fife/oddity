extends PlayerDetectionZone

class_name AsteroidZone

@export_category("Asteroid Zone")

@export
var asteroids : Array = Array()

@export_range(0, 15000, 100, "or_greater")
var spawn_radius : float

@export_range(0, 300, 1)
var asteroid_count : int

@export
var instanced_asteroids : Array = Array()

@export
var asteroid_ring : Node3D

@export
var asteroid_marker : PackedScene = preload("res://classes/player-detection-zone/asteroid-zone/AsteroidMarkerZone.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_asteroid_zone_ready()

func _asteroid_zone_ready() -> void:
	_player_detection_zone_ready()

	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)

	add_child(asteroid_marker.instantiate())

	if asteroid_ring != null:
		scale = Vector3(1 / asteroid_ring.scale.x, 1 / asteroid_ring.scale.y, 1 / asteroid_ring.scale.z)

func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	for i : int in asteroid_count:
		var asteroid : Minable = (asteroids.pick_random() as PackedScene).instantiate()

		asteroid.max_resource_health = randf_range(10000, 30000)
		asteroid.current_resource_health = asteroid.max_resource_health
		asteroid.resource_count = randi_range(4, 12)

		add_child(asteroid)
		asteroid.position = (Vector3(randf_range(0, spawn_radius/2), randf_range(-50, 50), randf_range(0, spawn_radius/2)))
		asteroid.rotation = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))
		asteroid.reparent(get_tree().get_first_node_in_group("StarSystem"))
		asteroid.scale = Vector3(1,1,1)
		instanced_asteroids.append(asteroid)


func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	for i : int in range(instanced_asteroids.size() - 1, -1, -1):
		instanced_asteroids[i].free()
		instanced_asteroids.remove_at(i)
