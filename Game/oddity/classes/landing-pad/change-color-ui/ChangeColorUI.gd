extends Node3D

class_name ChangeColorUI

@export_category("Components")

@export
var hue_comp : ColorComponentPickerUI

@export
var saturation_comp : ColorComponentPickerUI

@export
var value_comp : ColorComponentPickerUI

@export_category("Preview")

@export
var preview_mesh : MeshInstance3D

@export_category("Ship")

@export
var landing_pad : LandingPad

var ship : Starship

var init_completed : bool = false

var color : Color :
	set(value):
		color = value
		
		print("color changed: " + str(color))
		
		if ship != null and init_completed:
			preview_mesh.get_active_material(0).albedo_color = color
			ship.update_color(color)
	get:
		return color
	
func _ready() -> void:
	landing_pad.starship_landed.connect(on_ship_landed)
	landing_pad.starship_took_off.connect(on_ship_took_off)

func on_ship_landed(starship : Starship) -> void:
	ship = starship
	
	preview_mesh.get_active_material(0).albedo_color = ship.original_hull_color
	hue_comp.color_value = ship.original_hull_color.h * 360
	saturation_comp.color_value = ship.original_hull_color.s * 100
	value_comp.color_value = ship.original_hull_color.v * 100
	
	hue_comp.value_changed.connect(_on_hue_changed)
	saturation_comp.value_changed.connect(_on_saturation_changed)
	value_comp.value_changed.connect(_on_value_changed)
	
	init_completed = true
	
func on_ship_took_off(starship : Starship) -> void:
	ship = null
	init_completed = false
	
	if hue_comp.value_changed.is_connected(_on_hue_changed):
		hue_comp.value_changed.disconnect(_on_hue_changed)
	
	if saturation_comp.value_changed.is_connected(_on_saturation_changed):
		saturation_comp.value_changed.disconnect(_on_saturation_changed)
	
	if value_comp.value_changed.is_connected(_on_value_changed):
		value_comp.value_changed.disconnect(_on_value_changed)

func _on_hue_changed(value : float) -> void:
	color.h = value

func _on_saturation_changed(value : float) -> void:
	color.s = value

func _on_value_changed(value : float) -> void:
	color.v = value
