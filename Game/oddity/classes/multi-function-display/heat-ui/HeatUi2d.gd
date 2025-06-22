extends Control

class_name HeatUi2d

@export_category("Heat Values")

@export
var current_heat : float :
	set(value):
		current_heat = value
		heat_bar.value = value
	get():
		return current_heat

@export
var max_heat : float :
	set(value):
		heat_bar.max_value = value


@export_category("UI")

@export
var heat_bar : ProgressBar
