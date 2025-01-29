extends Node3D

class_name CargoSellingUi

@export
var cargo_selling_ui_2d : CargoSellingUi2d

@export
var connected_cargo_grid : CargoGrid

@export
var current_cargo : Array = Array()

func update(cargo_area : CargoArea, cargo : CargoContainer) -> void:
	current_cargo = connected_cargo_grid.current_cargo_in_grid
	cargo_selling_ui_2d.update(current_cargo)

func _ready() -> void:
	connected_cargo_grid.cargo_has_been_added_to_grid.connect(update)
	connected_cargo_grid.cargo_has_been_removed_from_grid.connect(update)

func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	if current_cargo.size() == 0:
		$No.play()
		return
	
	connected_cargo_grid.sell_cargo()
	cargo_selling_ui_2d.reset()
	$Sold.play()
