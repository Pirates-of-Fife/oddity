extends StarshipCommand

class_name StarshipShootSecondaryCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.shoot_secondary()
