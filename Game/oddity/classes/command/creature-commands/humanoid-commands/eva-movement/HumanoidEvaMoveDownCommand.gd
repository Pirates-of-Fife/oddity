extends HumanoidEvaMovementCommand

class_name HumanoidEvaMoveDownCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Humanoid:
		control_entity.eva_move_down()
