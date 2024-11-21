extends Node3D

class_name Crosshair3d

@export_range(-1, 1, 0.01)
var yaw : float

@export_range(-1, 1, 0.01)
var pitch : float

@export
var crosshair : Crosshair2d

func _process(delta: float) -> void:
	crosshair.yaw = yaw
	crosshair.pitch = pitch
