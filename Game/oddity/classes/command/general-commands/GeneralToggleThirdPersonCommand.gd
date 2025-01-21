extends Command

class_name GeneralToggleThirdPersonCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	control_entity.toggle_third_person()
