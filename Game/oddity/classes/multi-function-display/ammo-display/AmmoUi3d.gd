extends Node3D

class_name AmmoUi3d

@export
var starship : Starship

@export_category("UI")

@export
var ammo_ui_2d : AmmoUi2d

@export_category("Values")

@export
var current_ammo : float : 
	set(value):
		current_ammo = value
		ammo_ui_2d.current_ammo = value
		
@export
var max_ammo : float : 
	set(value):
		max_ammo = value
		ammo_ui_2d.max_ammo = value

func _ready() -> void:
	starship.max_ammo_changed.connect(_on_max_ammo_changed)
	starship.current_ammo_changed.connect(_on_current_ammo_changed)
	
func _on_max_ammo_changed(ammo : float) -> void:
	max_ammo = ammo
	print("max amo" + str(max_ammo))
	
func _on_current_ammo_changed(ammo : float) -> void:
	current_ammo = ammo
