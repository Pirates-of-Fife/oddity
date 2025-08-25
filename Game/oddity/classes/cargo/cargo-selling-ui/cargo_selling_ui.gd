extends Node3D

class_name CargoSellingUi

@export
var cargo_selling_ui_2d : CargoSellingUi2d

@export
var connected_cargo_grid : CargoGrid

@export
var connected_module_selling_area : ModuleSellingArea

@export
var current_cargo : Array = Array()

@export
var current_modules : Array = Array()

@export
var station_pad : StationPad

func update_cargo(cargo_area : CargoArea, cargo : CargoContainer) -> void:
	current_cargo = connected_cargo_grid.current_cargo_in_grid
	update_ui()

func update_modules() -> void:
	current_modules = connected_module_selling_area.modules.duplicate()
	current_modules.append_array(connected_module_selling_area.game_entities)
	update_ui()

func update_ui() -> void:
	cargo_selling_ui_2d.update(current_cargo, current_modules)

func _ready() -> void:
	connected_cargo_grid.cargo_has_been_added_to_grid.connect(update_cargo)
	connected_cargo_grid.cargo_has_been_removed_from_grid.connect(update_cargo)
	connected_module_selling_area.modules_updated.connect(update_modules)
	cargo_selling_ui_2d.station_pad = station_pad
	
func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	if current_cargo.size() == 0 and current_modules.size() == 0:
		$No.play()
		return
	
	if current_cargo.size() > 0:
		connected_cargo_grid.sell_cargo(station_pad.station)
	if current_modules.size() > 0:
		connected_module_selling_area.sell_modules(station_pad.station)
		current_modules.clear()
	
	cargo_selling_ui_2d.reset()
	$Sold.play()
	
	
