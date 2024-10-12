extends StarshipCommand

class_name StarshipPlayerInteractCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.use_interact()
