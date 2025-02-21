extends StaticGameEntity

class_name Minable

@export_category("Minable")

signal is_being_mined(damage : float, mining_position : Vector3)

@export
var max_resource_health : float

@export
var current_resource_health : float

@export
var resource_count : int

## Packed Scenes
@export
var extractable_resources : Array = Array()

@export
var resource_value_max : int = 10000

@export
var resource_value_min : int = 40000

@export
var minable_sound : PackedScene = preload("res://scenes/minables/asteroids/RockCrackSound.tscn")

func mine(damage : float, mining_position : Vector3, normal : Vector3) -> void:
	is_being_mined.emit(damage, mining_position)
	
	current_resource_health -= damage
	current_resource_health = clampf(current_resource_health, 0, max_resource_health)
		
	if current_resource_health == 0 and resource_count > 0:
		release_extractable(mining_position, normal)
		current_resource_health = max_resource_health
		resource_count -= 1

func release_extractable(pos : Vector3, normal : Vector3) -> void:
	var selected_extractable : PackedScene = extractable_resources.pick_random()
	
	var extractable : GameEntity = selected_extractable.instantiate()
	
	var force : Vector3 = normal * 150
	
	
	get_tree().get_first_node_in_group("StarSystem").add_child(extractable)
	extractable.global_position = pos
	extractable.apply_central_impulse(force)
	extractable.value = randi_range(resource_value_min, resource_value_max)
	
	var sound : MineableAudio = minable_sound.instantiate()
	extractable.add_child(sound)
	
