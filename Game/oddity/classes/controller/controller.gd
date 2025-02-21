extends Node

class_name Controller

@export_category("Control Entity")
@export
var control_entity : ControlEntity

var general_toggle_third_person_command : GeneralToggleThirdPersonCommand = GeneralToggleThirdPersonCommand.new()
var general_toggle_look_around_command : GeneralToggleLookAroundCommand = GeneralToggleLookAroundCommand.new()
var general_increase_third_person_distance_command : GeneralThirdPersonIncreaseDistanceCommand = GeneralThirdPersonIncreaseDistanceCommand.new()
var general_decrease_third_person_distance_command : GeneralThirdPersonDecreaseDistanceCommand = GeneralThirdPersonDecreaseDistanceCommand.new()

var look_around : bool = false
var third_person : bool = false

#==========================================================================================================================================#
# the _default methods contain the standard controls. A child class of a control entity may choose to add new controls to the default set. #
#==========================================================================================================================================#
func _ready() -> void:
	_controller_ready()

func _controller_process(delta : float) -> void:
	pass

func _controller_ready() -> void:
	pass
