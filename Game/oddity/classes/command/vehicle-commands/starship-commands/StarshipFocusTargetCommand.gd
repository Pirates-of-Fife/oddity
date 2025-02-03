extends StarshipCommand

class_name StarshipFocusTargetCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.focus_target()
