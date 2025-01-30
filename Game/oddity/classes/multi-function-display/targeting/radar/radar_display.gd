@tool

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

func _process(delta: float) -> void:
	var relative_position : Vector3 = target_position_relative_to_ship / 1000

	$RadarBlips/RadarBlip.position = relative_position

func spawn_radar_blip(game_entity : GameEntity) -> void:
	var radar_blip : Node3D

	if game_entity is Starship:
		if game_entity.is_targeted == true:
			radar_blip = targeted_radar_blip_scene.instantiate()
		else:
			radar_blip = radar_blip_scene.instantiate()
	else:
		radar_blip = radar_blip_scene.instantiate()

	$RadarBlips.add_child(radar_blip)

	var relative_position : Vector3 = (game_entity.global_position - starship.global_position) / 200

	radar_blip.position = relative_position




func _on_timer_timeout() -> void:
	for i : Node3D in $RadarBlips.get_children():
		i.queue_free()

	for i : GameEntity in radar_surrounding.entities:
		spawn_radar_blip(i)
