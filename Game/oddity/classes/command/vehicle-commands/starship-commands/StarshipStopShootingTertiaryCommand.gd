extends StarshipCommand

class_name StarshipStopShootingTertiaryCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.stop_shooting_tertiary()
