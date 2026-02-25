extends Node3D

class_name ColorComponentPickerUI

@export_category("Buttons")

@export
var decrease_value_button : InteractionButton

@export
var increase_value_button : InteractionButton

@export
var label : Label3D

@export_category("Configuration")

var min_value : float = 0

@export_range(0, 100, 0.1, "or_less", "or_greater")
var max_value : float

@export_range(0, 100, 0.1, "or_less", "or_greater")
var increment : float

var color_value : float = 0 :
	set(value):
		color_value = clampf(value, min_value, max_value)
		label.text = str(roundf(color_value))
		value_changed.emit(lerpf(0, 1, color_value / max_value))
	get:
		return color_value

signal value_changed(value : float)

func _ready() -> void:
	increase_value_button.interacted.connect(_on_increase)
	decrease_value_button.interacted.connect(_on_decrease)

func _on_increase(p : Player, c : ControlEntity) -> void:
	color_value += increment
	
func _on_decrease(p : Player, c : ControlEntity) -> void:
	color_value -= increment
