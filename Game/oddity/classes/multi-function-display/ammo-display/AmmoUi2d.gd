extends Control

class_name AmmoUi2d

@export_category("UI")
@export
var ammo_bar : ProgressBar

@export
var ammo_text : Label


@export_category("Values")

@export
var current_ammo : float : 
	set(value):
		current_ammo = value
		ammo_text.text = str(roundf(value)) + " IFV"
		ammo_bar.value = value
		
@export
var max_ammo : float : 
	set(value):
		max_ammo = value
		ammo_bar.max_value = value
