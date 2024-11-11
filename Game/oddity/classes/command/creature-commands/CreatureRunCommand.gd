extends CreatureCommand

class_name CreatureRunCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Creature:
		control_entity.run()
