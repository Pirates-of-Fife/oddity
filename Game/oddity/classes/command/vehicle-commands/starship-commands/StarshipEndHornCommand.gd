extends StarshipCommand

class_name StarshipEndHornCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.end_horn()
