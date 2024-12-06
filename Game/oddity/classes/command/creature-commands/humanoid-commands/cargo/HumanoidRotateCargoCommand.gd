extends HumanoidCommand

class_name HumanoidRotateCargoCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Humanoid:
		if control_entity.game_entity_being_picked_up is CargoContainer:
			control_entity.game_entity_being_picked_up.rotate_cargo()
