extends Command

class_name GeneralToggleLookAroundCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	control_entity.toggle_look_around()
