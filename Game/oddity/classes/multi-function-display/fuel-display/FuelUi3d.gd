extends Node3D

class_name FuelUi3d

@export
var starship : Starship

@export_category("UI")

@export
var fuel_ui_2d : FuelUi2d

@export_category("Values")

@export
var current_fuel : float : 
	set(value):
		current_fuel = value
		fuel_ui_2d.current_fuel = value
		
@export
var max_fuel : float : 
	set(value):
		max_fuel = value
		fuel_ui_2d.max_fuel = value

func _ready() -> void:
	starship.max_fuel_changed.connect(_on_max_fuel_changed)
	starship.current_fuel_changed.connect(_on_current_fuel_changed)
	
func _on_max_fuel_changed(fuel : float) -> void:
	max_fuel = fuel
	
func _on_current_fuel_changed(fuel : float) -> void:
	current_fuel = fuel
