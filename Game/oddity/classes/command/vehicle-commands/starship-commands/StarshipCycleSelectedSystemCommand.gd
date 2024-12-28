extends StarshipCommand

class_name StarshipCycleSelectedSystemCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.cycle_selected_system()
