extends Control

class_name RepairUi2d

@export
var ship_not_landed_ui : Control

@export
var ship_name : Label

@export_category("Refuel")
@export
var refuel_ui : Control

@export
var refuel_cost_label : Label

@export
var ship_refueled_ui : Control

@export_category("Repair")
@export
var repair_ui : Control

@export
var repair_cost_label : Label

@export
var ship_repaired_ui : Control

@export_category("Restock")

@export
var restock_ui : Control

@export
var restock_cost_label : Label

@export
var ship_restocked_ui : Control

func ship_landed(starship : Starship, repair_costs : String, refuel_costs : String, restock_costs : String) -> void:
	ship_not_landed_ui.hide()
	ship_repaired_ui.hide()
	ship_restocked_ui.hide()
	ship_refueled_ui.hide()
	
	repair_ui.show()
	refuel_ui.show()
	restock_ui.show()
	
	ship_name.text = starship.ship_name
	repair_cost_label.text = repair_costs
	refuel_cost_label.text = refuel_costs
	restock_cost_label.text = restock_costs

func ship_took_off() -> void:
	ship_repaired_ui.hide()
	ship_restocked_ui.hide()
	ship_refueled_ui.hide()
	repair_ui.hide()
	refuel_ui.hide()
	restock_ui.hide()
	
	ship_not_landed_ui.show()

func repaired() -> void:
	ship_repaired_ui.show()
	repair_ui.hide()
	ship_not_landed_ui.hide()

func restocked() -> void:
	ship_restocked_ui.show()
	restock_ui.hide()
	
func refueled() -> void:
	refuel_ui.hide()
	ship_refueled_ui.show()
