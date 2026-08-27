extends HumanoidCommand

class_name HumanoidMeowCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Humanoid:
		control_entity.meow()
