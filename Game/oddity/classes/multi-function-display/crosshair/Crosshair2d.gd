@tool

extends Control

class_name Crosshair2d

@export_range(-1, 1, 0.01)
var yaw : float

@export_range(-1, 1, 0.01)
var pitch : float

var width : float = 500

@export
var line : Line2D

@export
var dot : TextureRect

@export
var ring : TextureRect



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dot.position.y = -pitch * 250
	dot.position.x = yaw * 250
	
	line.points[1] = dot.position + Vector2(250, 250)
