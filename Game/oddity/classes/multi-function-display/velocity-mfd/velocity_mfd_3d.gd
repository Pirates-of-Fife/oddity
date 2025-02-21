extends Node3D

class_name VelocityMFD3D

@export
var vertical_velocity_up : float
@export
var vertical_velocity_down : float
@export
var lateral_velocity_left : float
@export
var lateral_velocity_right : float
@export
var forwards_velocity : float
@export
var max_velocity : float
@export
var current_max_velocity : float
@export
var throttle : float
@export
var velocity : float

@export
var velocity_mfd : VelocityMFD

func _process(delta: float) -> void:
	velocity_mfd.vertical_velocity_up = vertical_velocity_up
	velocity_mfd.vertical_velocity_down = vertical_velocity_down
	velocity_mfd.lateral_velocity_left = lateral_velocity_left
	velocity_mfd.lateral_velocity_right = lateral_velocity_right
	velocity_mfd.forwards_velocity = forwards_velocity
	velocity_mfd.max_velocity = max_velocity
	velocity_mfd.current_max_velocity = current_max_velocity
	velocity_mfd.throttle = throttle
	velocity_mfd.velocity = velocity
