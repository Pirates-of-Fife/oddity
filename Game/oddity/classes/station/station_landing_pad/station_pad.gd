extends StaticGameEntity

class_name StationPad

@export
var station : SpaceStation

@export
var tutorial_scene : PackedScene = preload("res://classes/station/station_landing_pad/Tutorial.tscn")

@export
var tutorial_visible : bool = false

@export
var tutorial : Node3D


func _on_landing_pad_starship_landed(starship: Starship) -> void:
	if station != null:
		station.player_stop_music()

func _on_landing_pad_starship_took_off(starship: Starship) -> void:
	if station != null:
		station.player_near_station()


func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	if tutorial_visible:
		tutorial.queue_free()
		tutorial_visible = false
	else:
		var t : Node3D = tutorial_scene.instantiate()
		$TutorialRoot.add_child(t)
		tutorial_visible = true
		tutorial = t
