extends HumanoidEvaMovementCommand

class_name HumanoidEvaMoveForwardsCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Humanoid:
		control_entity.eva_move_forwards()