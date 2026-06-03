extends StarshipCommand

class_name StarshipStartHornCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.start_horn()
