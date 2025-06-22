extends Node3D

class_name HeatUi

@export_category("UI")

@export
var heat_ui_2d : HeatUi2d

@export_category("Ship")

@export
var ship : Starship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.ready.connect(_ship_ready)

func _ship_ready() -> void:
	ship.heat_changed.connect(_on_heat_changed)
	heat_ui_2d.max_heat = ship.maximum_heat_capacity

func _on_heat_changed(heat : float) -> void:
	heat_ui_2d.current_heat = heat
