extends StarshipCommand

class_name  StarshipShootPrimaryCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.shoot_primary()
