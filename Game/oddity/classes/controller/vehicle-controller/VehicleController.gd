extends Controller

class_name VehicleController

var vehicle_exit_seat_command : VehicleExitSeatCommand = VehicleExitSeatCommand.new()

func _ready() -> void:
	_vehicle_ready()

func _vehicle_ready() -> void:
	_controller_ready()
