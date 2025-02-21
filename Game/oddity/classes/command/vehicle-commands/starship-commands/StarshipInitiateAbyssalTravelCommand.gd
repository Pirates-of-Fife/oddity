extends StarshipCommand

class_name StarshipInitiateAbyssalTravelCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.initiate_abyssal_travel()
