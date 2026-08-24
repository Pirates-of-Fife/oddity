@tool
extends Node3D

class_name TradeResourceHelper

@export
var components : Array[TradeResource]

@export
var weapons : Array[TradeResource]

@export_category("Baselines")

@export
var component_0_value : int

@export
var component_0_preview_distance : float

@export
var component_1_value : int

@export
var component_1_preview_distance : float

@export
var component_2_value : int

@export
var component_2_preview_distance : float

@export
var component_3_value : int

@export
var component_3_preview_distance : float

@export
var component_4_value : int

@export
var component_4_preview_distance : float

@export
var component_5_value : int

@export
var component_5_preview_distance : float

@export
var component_6_value : int

@export
var component_6_preview_distance : float

@export
var weapon_2_value : int

@export
var weapon_2_preview_distance : float

@export
var weapon_3_value : int

@export
var weapon_3_preview_distance : float

@export
var weapon_4_value : int

@export
var weapon_4_preview_distance : float

@export
var weapon_5_value : int

@export
var weapon_5_preview_distance : float

@export
var weapon_6_value : int

@export
var weapon_6_preview_distance : float

@export
var weapon_8_value : int

@export
var weapon_8_preview_distance : float
@export
var run : bool :
	set(value):
		balance()	
		
func balance() -> void:
	for c : TradeResource in components:
		match c.size:
			0:
				c.value = component_0_value
				c.preview_distance = component_0_preview_distance
			1:
				c.value = component_1_value
				c.preview_distance = component_1_preview_distance
			2:
				c.value = component_2_value
				c.preview_distance = component_2_preview_distance
			3:
				c.value = component_3_value
				c.preview_distance = component_3_preview_distance
			4:
				c.value = component_4_value
				c.preview_distance = component_4_preview_distance
			5:
				c.value = component_5_value
				c.preview_distance = component_5_preview_distance
			6:
				c.value = component_6_value
				c.preview_distance = component_6_preview_distance

	for w : TradeResource in weapons:
		match w.size:
			2:
				w.value = weapon_2_value
				w.preview_distance = weapon_2_preview_distance
			3:
				w.value = weapon_3_value
				w.preview_distance = weapon_3_preview_distance
			4:
				w.value = weapon_4_value
				w.preview_distance = weapon_4_preview_distance
			5:
				w.value = weapon_5_value
				w.preview_distance = weapon_5_preview_distance
			6:
				w.value = weapon_6_value
				w.preview_distance = weapon_6_preview_distance
			8:
				w.value = weapon_8_value
				w.preview_distance = weapon_8_preview_distance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
