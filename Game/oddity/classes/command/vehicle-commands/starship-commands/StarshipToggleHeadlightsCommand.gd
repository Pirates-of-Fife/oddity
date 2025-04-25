extends StarshipCommand

class_name StarshipToggleHeadlightsCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		if control_entity.headlight_left.visible:
			control_entity.headlight_left.hide()
			control_entity.headlight_right.hide()
		else:
			control_entity.headlight_left.show()
			control_entity.headlight_right.show()
