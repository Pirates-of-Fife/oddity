extends StarshipCommand

class_name StarshipCyclePowerStateCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.toggle_power_state()
