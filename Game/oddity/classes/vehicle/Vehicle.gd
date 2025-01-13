# @class Vehicle
# Base Class for all Vehicles

extends ControlEntity

class_name Vehicle

@export_category("Control Seats")

@export
var active_control_seat : ControlSeat

func exit_seat() -> void:
	active_control_seat.exit_seat()

func _vehicle_process(delta : float) -> void:
	_control_entity_process(delta)
