extends Resource

class_name ThrusterForces

#=======================================================================================#
# Temporary resource class for thruster forces until thrusters get properly implemented #
#=======================================================================================#

@export_category("Movement")

@export
var forward_thrust : float

@export
var backward_thrust : float

@export
var up_thrust : float

@export
var down_thrust : float

@export
var left_thrust : float

@export
var right_thrust : float

@export_category("Rotation")

@export
var roll_left_thrust : float

@export
var roll_right_thrust : float

@export
var yaw_left_thrust : float

@export
var yaw_right_thrust : float

@export
var pitch_up_thrust : float

@export
var pitch_down_thrust : float
