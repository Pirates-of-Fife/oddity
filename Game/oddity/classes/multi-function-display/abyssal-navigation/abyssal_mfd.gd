extends Control

class_name AbyssalMFD

@export
var current_system : RichTextLabel

@export
var selected_system : RichTextLabel

@export
var gateway_open : RichTextLabel

@export
var gateway_closed : RichTextLabel

func set_current_system(system : String) -> void:
	current_system.text = "Current: " + system
	
func set_selected_system(system : String) -> void:
	current_system.text = "Selected: " + system
	
func set_gateway_closed() -> void:
	gateway_closed.show()
	gateway_open.hide()

func set_gateway_open() -> void:
	gateway_closed.hide()
	gateway_open.show()
