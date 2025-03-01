extends Node3D

class_name AbyssalMFD3D

@export
var abyssal_mfd : AbyssalMFD

func set_current_system(system : String) -> void:
	abyssal_mfd.set_current_system(system)
	
func set_selected_system(system : String) -> void:
	abyssal_mfd.set_selected_system(system)
	
func set_gateway_closed() -> void:
	abyssal_mfd.set_gateway_closed()

func set_gateway_open() -> void:
	abyssal_mfd.set_gateway_open()
