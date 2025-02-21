extends Command

class_name GeneralThirdPersonDecreaseDistanceCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	control_entity.third_person_decrease_distance()
