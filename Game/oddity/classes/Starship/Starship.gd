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

#func _physics_process(delta):
#	# Example: forward movement control
#	var forward_input = get_input_axis_value() # Placeholder for your actual input method
#	var forward_output = pid_forward.calculate(forward_input, delta)
#	apply_thrust_in_direction(forward_output, Vector3.FORWARD)  # Apply thrust to the ship


var acceleration : Vector3 = Vector3.ZERO
var local_linear_velocity : Vector3 = Vector3.ZERO
var local_angular_velocity : Vector3 = Vector3.ZERO

var local_linear_velocity_last_frame : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	calculate_local_linear_velocity()
	calculate_local_angular_velocity()
	calculate_acceleration(delta)
	
	var target_speed_vector : Vector3 = calculate_target_speed_vector()
	var target_rotation_speed_vector : Vector3 = calculate_target_rotation_speed_vector()
		

	var forwards_thrust : float = pid_forward.update(target_speed_vector.z, local_linear_velocity.z, delta)
	var backwards_thrust : float = pid_backward.update(target_speed_vector.z, local_linear_velocity.z, delta)
	
	print("FORARDS: " + str(forwards_thrust))
	print("Backward" + str(backwards_thrust))
	
	#apply_central_force(Vector3(0,0, forwards_thrust))
	
	# reset thrust vector
	reset_thrust_vectors()

func reset_thrust_vectors() -> void:
	target_thrust_vector = Vector3.ZERO
	target_rotational_thrust_vector = Vector3.ZERO

func flight_calculations() -> void:
	#pid_controller.update()
	pass

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

func set_target_thrust_up(thrust : float) -> void:
	target_thrust_vector.y = thrust

func set_target_thrust_down(thrust : float) -> void:
	target_thrust_vector.y = -thrust
	
func set_target_thrust_left(thrust : float) -> void:
	target_thrust_vector.x = -thrust
	
func set_target_thrust_right(thrust : float) -> void:
	target_thrust_vector.x = thrust

func set_target_thrust_forward(thrust : float) -> void:
	target_thrust_vector.z = -thrust

func set_target_thrust_backward(thrust : float) -> void:
	target_thrust_vector.z = thrust
	
func set_target_rotation_pitch_up(thrust : float) -> void:
	target_rotational_thrust_vector.x = thrust

func set_target_rotation_pitch_down(thrust : float) -> void:
	target_rotational_thrust_vector.x = -thrust
	
func set_target_rotation_yaw_left(thrust : float) -> void:
	target_rotational_thrust_vector.y = thrust
	
func set_target_rotation_yaw_right(thrust : float) -> void:
	target_rotational_thrust_vector.y = -thrust

func set_target_rotation_roll_left(thrust : float) -> void:
	target_rotational_thrust_vector.z = thrust

func set_target_rotation_roll_right(thrust : float) -> void:
	target_rotational_thrust_vector.z = -thrust
