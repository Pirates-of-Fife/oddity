extends Control

class_name HeatUi2d

@export_category("Heat Values")

@export
var current_heat : float :
	set(value):
		current_heat = value
		heat_bar.value = value
		$CurrentHeat.text = str(roundf(value))
	get():
		return current_heat

@export
var max_heat : float :
	set(value):
		heat_bar.max_value = value

@export
var current_cool : float :
	set(value):
		current_cool = value
		cool_bar.value = value
		$CurrentCool.text = str(roundf(value))
	get():
		return current_cool

@export
var max_cool : float :
	set(value):
		cool_bar.max_value = value

@export_category("UI")

@export
var heat_bar : ProgressBar

@export
var cool_bar : ProgressBar


func hide_cool_bar() -> void:
	cool_bar.hide()
	$CoolSymbol.hide()
	$CurrentCool.hide()

func show_cool_bar() -> void:
	cool_bar.show()
	$CoolSymbol.show()
	$CurrentCool.show()
