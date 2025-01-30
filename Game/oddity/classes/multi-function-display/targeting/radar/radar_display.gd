extends Node3D

class_name RadarDisplay

@export
var target_position_relative_to_ship : Vector3

@export
var starship : Starship

@export
var radar_blip_scene : PackedScene

@export
var targeted_radar_blip_scene : PackedScene

@export
var radar_radius : float

var radar_surrounding : RadarSurroundingArea
var radar_focus : RadarFocusArea

func _ready() -> void:
	radar_focus = starship.radar_focus_area
	radar_surrounding = starship.radar_surrounding_area

#func _process(delta: float) -> void:
#	return

#	var relative_position: Vector3 = target_position_relative_to_ship
#	var distance: float = relative_position.length()

	# Apply logarithmic scaling
#	var scaled_distance : float = log(1 + distance) / log(2)  # Base 2 logarithm scaling
#	var direction : Vector3 = relative_position.normalized()

#	# Scale down by a factor to fit within radar bounds
#	$RadarBlips/RadarBlip.position = (direction * scaled_distance) / 10

func spawn_radar_blip(game_entity : GameEntity) -> void:
	var radar_blip : Node3D

	if game_entity is Starship:
		if game_entity.is_targeted == true:
			radar_blip = targeted_radar_blip_scene.instantiate()
		else:
			radar_blip = radar_blip_scene.instantiate()
	else:
		radar_blip = radar_blip_scene.instantiate()

	var relative_position: Vector3 = starship.global_position - game_entity.global_position

	#print(relative_position)

	var distance: float = relative_position.length()

	# Apply logarithmic scaling
	var scaled_distance : float = log(1 + distance) / log(2)  # Base 2 logarithm scaling
	var direction : Vector3 = relative_position.normalized()

	$RadarBlips.add_child(radar_blip)

	# Scale down by a factor to fit within radar bounds
	radar_blip.position = (direction * scaled_distance) / 15

	print(radar_blip.position)


func _on_timer_timeout() -> void:
	pass
	#for i : Node3D in $RadarBlips.get_children():
		#i.queue_free()

	#for i : GameEntity in radar_surrounding.entities:
		#spawn_radar_blip(i)
		#print("Spawn")
