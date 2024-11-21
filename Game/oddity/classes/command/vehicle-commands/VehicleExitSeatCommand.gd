extends VehicleCommand

class_name  VehicleExitSeatCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Vehicle:
		control_entity.exit_seat()
