extends StarshipCommand

class_name StarshipInitiateSuperCruiseCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.initiate_super_cruise()
