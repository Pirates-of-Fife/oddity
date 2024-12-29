extends Node3D

class_name SuperCruiseMFD3D

var throttle : float
var velocity : float
var max_velocity : float
var velocity_c : float


@export
var super_cruise_mfd : SuperCruiseMFD

func _process(delta: float) -> void:
	super_cruise_mfd.max_velocity = max_velocity
	super_cruise_mfd.throttle = throttle
	super_cruise_mfd.velocity_c = velocity_c
	super_cruise_mfd.velocity = velocity
