extends Control

class_name FuelUi2d

@export_category("UI")
@export
var fuel_bar : ProgressBar

@export
var fuel_text : Label


@export_category("Values")

@export
var current_fuel : float : 
	set(value):
		current_fuel = value
		fuel_text.text = str(roundf(value)) + " IFV"
		fuel_bar.value = value
		
@export
var max_fuel : float : 
	set(value):
		max_fuel = value
		fuel_bar.max_value = value
