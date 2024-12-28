extends StarshipCommand

class_name StarshipToggleLandingGearCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.toggle_landing_gear()
