extends EngineeringTerminalCommand

class_name EngineeringTerminalExitCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is EngineeringTerminal:
		control_entity.exit_terminal()
