extends Node

class_name Controller

@export_category("Control Entity")
@export
var control_entity : ControlEntity

#==========================================================================================================================================#
# the _default methods contain the standard controls. A child class of a control entity may choose to add new controls to the default set. #
#==========================================================================================================================================#
func _controller_process(delta : float) -> void:
	pass

func _controller_ready() -> void:
	pass
