@tool
extends Node3D

class_name AsteroidBelt

@export
var belt_rotation : Vector3

@export
var outer_radius : float :
	get():
		return scale.z * 5
		
@export
var inner_radius : float :
	get():
		return outer_radius / 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		global_rotation = belt_rotation
