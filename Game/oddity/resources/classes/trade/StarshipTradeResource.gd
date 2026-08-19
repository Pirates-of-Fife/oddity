extends TradeResource

class_name StarshipTradeResource

@export
var manufacturer_logo : Texture2D

@export
var logo_scale : float

@export
var component_description : PackedStringArray

var forwards_accelleration : float = snappedf(thruster_force.forward_thrust * 0.75 / 5000 / 9.81, 0.1)
var retro_accelleration : float = snappedf(thruster_force.backward_thrust * 0.75 / 5000 / 9.81, 0.1)
var lateral_accelleration : float = snappedf(thruster_force.left_thrust * 0.75 / 5000 / 9.81, 0.1)
var vertical_acceleration : float = snappedf(thruster_force.up_thrust * 0.75 / 5000 / 9.81, 0.1)

var pitch : float = snappedf(rad_to_deg(ship_info.max_angular_pitch_velocity), 0.1)
var yaw : float = snappedf(rad_to_deg(ship_info.max_angular_yaw_velocity), 0.1)
var roll : float = snappedf(rad_to_deg(ship_info.max_angular_roll_velocity), 0.1)

@export
var cargo_capacity : int

@export
var thruster_force : ThrusterForces

@export
var ship_info : StarshipInfo
