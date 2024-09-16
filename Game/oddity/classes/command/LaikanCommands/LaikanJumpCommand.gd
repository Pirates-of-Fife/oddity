extends LaikanCommand

class_name LaikanJumpCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Laikan:
		control_entity.jump()
