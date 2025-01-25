extends Control

class_name RepairUi2d

@export
var ship_landed_ui : Control

@export
var ship_not_landed_ui : Control

@export
var ship_repaired_ui : Control

@export
var ship_name : Label

@export
var cost_label : Label

func ship_landed(starship : Starship, repair_costs : String) -> void:
	ship_landed_ui.show()
	ship_not_landed_ui.hide()
	ship_repaired_ui.hide()
	
	ship_name.text = starship.ship_name
	cost_label.text = repair_costs

func ship_took_off() -> void:
	ship_repaired_ui.hide()
	ship_landed_ui.hide()
	ship_not_landed_ui.show()

func repaired() -> void:
	ship_repaired_ui.show()
	ship_landed_ui.hide()
	ship_not_landed_ui.hide()
