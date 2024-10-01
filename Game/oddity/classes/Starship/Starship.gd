# @class Vehicle
# Base Class for all Starships

extends Vehicle

class_name Starship

@export_category("Target Thrust Vector")

@export
var target_thrust_vector : Vector3 = Vector3.ZERO

@export
var target_rotational_thrust_vector : Vector3 = Vector3.ZERO

@export_category("Info")

@export
var ship_info : StarshipInfo 

@export
var thruster_force : ThrusterForces

@onready 
var pid_forward : PIDController = $PIDControllers/PIDForward
@onready
var pid_backward : PIDController = $PIDControllers/PIDBackward
@onready
var pid_up : PIDController = $PIDControllers/PIDUp
@onready
var pid_down : PIDController = $PIDControllers/PIDDown
@onready
var pid_left : PIDController = $PIDControllers/PIDLeft
@onready
var pid_right : PIDController = $PIDControllers/PIDRight

@onready 
var pid_roll_left : PIDController =  $PIDControllers/PIDRollLeft
@onready 
var pid_roll_right : PIDController =  $PIDControllers/PIDRollRight
@onready 
var pid_yaw_left : PIDController =  $PIDControllers/PIDYawLeft
@onready 
var pid_yaw_right : PIDController =  $PIDControllers/PIDYawRight
@onready 
var pid_pitch_up : PIDController =  $PIDControllers/PIDPitchUp
@onready 
var pid_pitch_down : PIDController =  $PIDControllers/PIDPitchDown

var epsilon : float = 0.0001

var acceleration : Vector3 = Vector3.ZERO
var local_linear_velocity : Vector3 = Vector3.ZERO
var local_angular_velocity : Vector3 = Vector3.ZERO

var local_linear_velocity_last_frame : Vector3 = Vector3.ZERO

var target_speed_vector : Vector3 
var target_rotation_speed_vector : Vector3

var actual_thrust_vector : Vector3 = Vector3.ZERO
var actual_rotation_vector : Vector3 = Vector3.ZERO

var relative_gravity_vector : Vector3 = Vector3.ZERO
var relative_gravity_direction : Vector3 = Vector3.ZERO
var gravity_strength : float = 0

func _ready() -> void:
	pid_forward.limit_max = thruster_force.forward_thrust
	pid_backward.limit_max = thruster_force.backward_thrust
	pid_up.limit_max = thruster_force.up_thrust
	pid_down.limit_max = thruster_force.down_thrust
	pid_left.limit_max = thruster_force.left_thrust
	pid_right.limit_max = thruster_force.right_thrust
	
	pid_roll_left.limit_max = thruster_force.roll_left_thrust
	pid_roll_right.limit_max = thruster_force.roll_right_thrust
	pid_yaw_left.limit_max = thruster_force.yaw_left_thrust
	pid_yaw_right.limit_max = thruster_force.yaw_right_thrust
	pid_pitch_up.limit_max = thruster_force.pitch_up_thrust
	pid_pitch_down.limit_max = thruster_force.pitch_down_thrust

func _physics_process(delta: float) -> void:
	calculate_local_linear_velocity()
	calculate_local_angular_velocity()
	calculate_acceleration(delta)
		
	target_speed_vector = calculate_target_speed_vector()
	target_rotation_speed_vector = calculate_target_rotation_speed_vector()
	
	var velocity_delta : float = 0
	var thrust : float = 0
	
	# forwards axis

	relative_gravity_vector = relative_gravity_vector * mass

	velocity_delta = local_linear_velocity.z - target_speed_vector.z
		
	if (velocity_delta < 0):
		thrust = pid_forward.update(target_speed_vector.z, local_linear_velocity.z, delta)
		thrust_forward(thrust + relative_gravity_vector.z)
	if (velocity_delta > 0):
		thrust = pid_backward.update(target_speed_vector.z, local_linear_velocity.z, delta)
		thrust_backward(thrust - relative_gravity_vector.z)
	
	# Up/Down axis

	velocity_delta = local_linear_velocity.y - target_speed_vector.y
		
	if (velocity_delta < 0):
		thrust = pid_up.update(target_speed_vector.y, local_linear_velocity.y, delta)
		thrust_up(thrust - relative_gravity_vector.y)
	if (velocity_delta > 0):
		thrust = pid_down.update(target_speed_vector.y, local_linear_velocity.y, delta)
		thrust_down(thrust + relative_gravity_vector.y )
		

	# Left/Right axis

	velocity_delta = local_linear_velocity.x - target_speed_vector.x
		
	if (velocity_delta < 0):
		thrust = pid_left.update(target_speed_vector.x, local_linear_velocity.x, delta)
		thrust_left(thrust + relative_gravity_vector.x)
	if (velocity_delta > 0):
		thrust = pid_right.update(target_speed_vector.x, local_linear_velocity.x, delta)
		thrust_right(thrust - relative_gravity_vector.x)
		
	# Pitch axis

	velocity_delta = local_angular_velocity.x - target_rotation_speed_vector.x

	if (velocity_delta > 0):
		thrust = pid_pitch_up.update(target_rotation_speed_vector.x, local_angular_velocity.x, delta)
		pitch_up(thrust)
	if (velocity_delta < 0):
		thrust = pid_pitch_down.update(target_rotation_speed_vector.x, local_angular_velocity.x, delta)
		pitch_down(thrust)
	
	# Yaw axis

	velocity_delta = local_angular_velocity.y - target_rotation_speed_vector.y
		
	if (velocity_delta < 0):
		thrust = pid_yaw_left.update(target_rotation_speed_vector.y, local_angular_velocity.y, delta)
		yaw_left(thrust)
	if (velocity_delta > 0):
		thrust = pid_yaw_right.update(target_rotation_speed_vector.y, local_angular_velocity.y, delta)
		yaw_right(thrust)


	# Roll axis

	velocity_delta = local_angular_velocity.z - target_rotation_speed_vector.z
		
	if (velocity_delta < 0):
		thrust = pid_roll_left.update(target_rotation_speed_vector.z, local_angular_velocity.z, delta)
		roll_right(thrust)

	if (velocity_delta > 0):
		thrust = pid_roll_right.update(target_rotation_speed_vector.z, local_angular_velocity.z, delta)
		roll_left(thrust)
	
	apply_central_force(actual_thrust_vector * global_basis.inverse())
	
	apply_torque(actual_rotation_vector * global_basis.inverse())
	
	# reset thrust vector
	reset_thrust_vectors()
	
	relative_gravity_vector = Vector3.ZERO

func reset_thrust_vectors() -> void:
	target_thrust_vector = Vector3.ZERO
	target_rotational_thrust_vector = Vector3.ZERO

func calculate_acceleration(delta : float) -> void:
	acceleration = (snapped(local_linear_velocity, Vector3(0.1, 0.1, 0.1)) - snapped(local_linear_velocity_last_frame, Vector3(0.1, 0.1, 0.1))) / delta
	local_linear_velocity_last_frame = local_linear_velocity

func calculate_local_linear_velocity() -> void:
	local_linear_velocity = transform.basis.inverse() * linear_velocity

func calculate_local_angular_velocity() -> void:
	local_angular_velocity = transform.basis.inverse() * angular_velocity

func calculate_target_speed_vector() -> Vector3:
	return target_thrust_vector * ship_info.max_linear_velocity

func calculate_target_rotation_speed_vector() -> Vector3:
	var new_target_vector : Vector3 = target_rotational_thrust_vector
	
	new_target_vector.x *= ship_info.max_angular_pitch_velocity
	new_target_vector.y *= ship_info.max_angular_yaw_velocity
	new_target_vector.z *= ship_info.max_angular_roll_velocity
	
	return new_target_vector

#===========================================================================#

func thrust_up(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.up_thrust)  
	actual_thrust_vector.y = thrust

func thrust_down(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.down_thrust)  
	actual_thrust_vector.y = -thrust  

func thrust_forward(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.forward_thrust) 
	actual_thrust_vector.z = thrust

func thrust_backward(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.backward_thrust) 
	actual_thrust_vector.z = -thrust 

func thrust_left(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.left_thrust)  
	actual_thrust_vector.x = thrust

func thrust_right(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.right_thrust)
	actual_thrust_vector.x = -thrust  

func roll_left(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.roll_left_thrust)  
	actual_rotation_vector.z = -thrust

func roll_right(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.roll_right_thrust) 
	actual_rotation_vector.z = thrust

func yaw_left(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.yaw_left_thrust) 
	actual_rotation_vector.y = thrust 

func yaw_right(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.yaw_right_thrust)
	actual_rotation_vector.y = -thrust

func pitch_up(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.pitch_up_thrust)
	actual_rotation_vector.x = -thrust

func pitch_down(thrust: float) -> void:
	thrust = clampf(thrust, 0, thruster_force.pitch_down_thrust)
	actual_rotation_vector.x = thrust



#===========================================================================#

func set_target_thrust_up(thrust : float) -> void:
	target_thrust_vector.y = thrust

func set_target_thrust_down(thrust : float) -> void:
	target_thrust_vector.y = -thrust
	
func set_target_thrust_left(thrust : float) -> void:
	target_thrust_vector.x = thrust
	
func set_target_thrust_right(thrust : float) -> void:
	target_thrust_vector.x = -thrust

func set_target_thrust_forward(thrust : float) -> void:
	target_thrust_vector.z = thrust

func set_target_thrust_backward(thrust : float) -> void:
	target_thrust_vector.z = -thrust
	
func set_target_rotation_pitch_up(thrust : float) -> void:
	target_rotational_thrust_vector.x = thrust

func set_target_rotation_pitch_down(thrust : float) -> void:
	target_rotational_thrust_vector.x = -thrust
	
func set_target_rotation_yaw_left(thrust : float) -> void:
	target_rotational_thrust_vector.y = -thrust
	
func set_target_rotation_yaw_right(thrust : float) -> void:
	target_rotational_thrust_vector.y = thrust

func set_target_rotation_roll_left(thrust : float) -> void:
	target_rotational_thrust_vector.z = -thrust

func set_target_rotation_roll_right(thrust : float) -> void:
	target_rotational_thrust_vector.z = thrust
