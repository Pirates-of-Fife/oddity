extends Node3D

class_name ShieldAndHullUi3D

@export_category("Values")
@export
var max_hull_health : float
@export
var current_hull_health : float

@export
var current_shield_health : float
@export
var max_shield_health : float

@export
var current_cooldown : float
@export
var cooldown_time : float

@export_category("Ui")
@export
var ui : ShieldAndHullUi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.hull_health_bar.max_value = max_hull_health
	ui.hull_health_bar.value = current_hull_health

	ui.shield_health_bar.max_value = max_shield_health
	ui.shield_health_bar.value = current_shield_health

	ui.shield_charge.max_value = cooldown_time
	ui.shield_charge.value = cooldown_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ui.max_hull_health = max_hull_health
	ui.current_hull_health = current_hull_health

	ui.max_shield_health = max_shield_health
	ui.current_shield_health = current_shield_health

	ui.cooldown_time = cooldown_time
	ui.current_cooldown = current_cooldown
