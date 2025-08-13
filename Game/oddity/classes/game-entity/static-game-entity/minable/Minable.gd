extends StaticGameEntity

class_name Minable

@export_category("Minable")

signal is_being_mined(damage : float, mining_position : Vector3)
signal resource_depleted

@export
var max_resource_health : float

@export
var current_resource_health : float

@export
var rarity : float 

@export
var resource_count : int

## Packed Scenes
@export
var extractable_resources : Array = Array()

@export
var base_value : int

@export
var value_variance : float

@export
var minable_sound : PackedScene = preload("res://scenes/minables/asteroids/RockCrackSound.tscn")

@export
var mineable_resource : MineableResource

@export
var extraction_force : float

func _ready() -> void:
	if mineable_resource == null:
		printerr("NO MINEABLE RESOURCE FOUND")
		return
		
	max_resource_health = randf_range(mineable_resource.min_resource_health, mineable_resource.max_resource_health)
	rarity = randf_range(mineable_resource.min_rarity, mineable_resource.max_rarity)
	resource_count = randi_range(mineable_resource.min_resource_count, mineable_resource.max_resource_count)
	extractable_resources = mineable_resource.extractable_resources
	base_value = mineable_resource.base_value
	value_variance = mineable_resource.value_variance
	minable_sound = mineable_resource.extraction_sound
	extraction_force = mineable_resource.extraction_force

func mine(damage : float, mining_position : Vector3, normal : Vector3) -> void:
	is_being_mined.emit(damage, mining_position)
	
	current_resource_health -= damage
	current_resource_health = clampf(current_resource_health, 0, max_resource_health)
		
	if current_resource_health == 0 and resource_count > 0:
		release_extractable(mining_position, normal)
		current_resource_health = max_resource_health
		resource_count -= 1
	
	if resource_count == 0:
		resource_depleted.emit()

func release_extractable(pos : Vector3, normal : Vector3) -> void:
	var selected_extractable : PackedScene = extractable_resources.pick_random()
	
	var extractable : GameEntity = selected_extractable.instantiate()
	
	var force : Vector3 = normal * extraction_force
	
	get_tree().get_first_node_in_group("StarSystem").add_child(extractable)
	extractable.global_position = pos
	extractable.apply_central_impulse(force)
	extractable.value = randi_range(base_value * (1 - value_variance), base_value * (1 + value_variance)) * rarity
	
	print(extractable.value)
	
	var sound : MineableAudio = minable_sound.instantiate()
	extractable.add_child(sound)
	
