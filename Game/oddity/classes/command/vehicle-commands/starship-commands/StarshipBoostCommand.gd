extends StarshipCommand

class_name StarshipBoostCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.boost()
