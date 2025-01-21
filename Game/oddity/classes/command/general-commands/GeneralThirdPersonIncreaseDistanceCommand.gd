extends Command

class_name GeneralThirdPersonIncreaseDistanceCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	control_entity.third_person_increase_distance()
