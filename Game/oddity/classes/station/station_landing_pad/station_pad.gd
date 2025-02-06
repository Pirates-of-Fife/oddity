extends StaticGameEntity

class_name StationPad

@export
var station : SpaceStation

func _on_landing_pad_starship_landed(starship: Starship) -> void:
	station.player_stop_music()

func _on_landing_pad_starship_took_off(starship: Starship) -> void:
	station.player_near_station()


func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	if $Tutorial.visible:
		$Tutorial.hide()
	else:
		$Tutorial.show()
