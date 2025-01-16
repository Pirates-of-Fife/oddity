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

@export_category("Accelerations")

@export
var forward_acceleration : float

@export
var backward_acceleration : float

@export
var up_acceleration : float

@export
var down_acceleration : float

@export
var left_acceleration : float

@export
var right_acceleration : float

@export
var roll_left_acceleration : float

@export
var roll_right_acceleration : float

@export
var yaw_left_acceleration : float

@export
var yaw_right_acceleration : float

@export
var pitch_up_acceleration : float

@export
var pitch_down_acceleration : float

@export_category("Decelerations")

@export
var forward_deceleration : float

@export
var backward_deceleration : float

@export
var up_deceleration : float

@export
var down_deceleration : float

@export
var left_deceleration : float

@export
var right_deceleration : float

@export
var roll_left_deceleration : float

@export
var roll_right_deceleration : float

@export
var yaw_left_deceleration : float

@export
var yaw_right_deceleration : float

@export
var pitch_up_deceleration : float

@export
var pitch_down_deceleration : float
