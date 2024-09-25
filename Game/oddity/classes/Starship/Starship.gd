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

func _ready() -> void:
	pid_forward.limit_max = thruster_force.forward_thrust
	pid_backward.limit_max = thruster_force.backward_thrust

func _physics_process(delta: float) -> void:
	calculate_local_linear_velocity()
	calculate_local_angular_velocity()
	calculate_acceleration(delta)
	
	target_speed_vector = calculate_target_speed_vector()
	target_rotation_speed_vector = calculate_target_rotation_speed_vector()
	
	var velocity_delta : float = 0
	var thrust : float = 0
	
	# forwards axis
	var forwards_thrust : float
	
	var forwards_speed_delta : float = target_speed_vector.z - local_linear_velocity.z
	
	print("DELTA " + str(forwards_speed_delta) )
	print("Speed: " + str(local_linear_velocity.z) + " Target: " + str(target_speed_vector.z))
	
	velocity_delta = local_linear_velocity.z - target_speed_vector.z
	
	if (velocity_delta < 0):
		thrust = pid_forward.update(target_speed_vector.z, local_linear_velocity.z, delta)
		thrust_forward(thrust)
	if (velocity_delta > 0):
		thrust = pid_backward.update(target_speed_vector.z, local_linear_velocity.z, delta)
		thrust_backward(thrust)
		
	print("TH " + str(thrust))
	
	#print("AXIS: " + str(get_target_forwards_axis_movement()))
	#print("THRUST: " + str(forwards_thrust))
	
	#var forwards_thrust : float = pid_forward.update(target_speed_vector.z, local_linear_velocity.z, delta)
	#var backwards_thrust : float = pid_backward.update(target_speed_vector.z, local_linear_velocity.z, delta)
	
	
	apply_central_force(actual_thrust_vector * global_basis.inverse())
	# reset thrust vector
	reset_thrust_vectors()

func reset_thrust_vectors() -> void:
	target_thrust_vector = Vector3.ZERO
	target_rotational_thrust_vector = Vector3.ZERO

func flight_calculations() -> void:
	#pid_controller.update()
	pass

func get_forwards_axis_movement() -> MovementDirection:
	if (local_linear_velocity.z > epsilon):
		return MovementDirection.BACKWARD
	if (local_linear_velocity.z < -epsilon):
		return MovementDirection.FORWARD
	
	return MovementDirection.NONE

func get_target_forwards_axis_movement() -> MovementDirection:
	if (target_speed_vector.z > epsilon):
		return MovementDirection.BACKWARD
	if (target_speed_vector.z < -epsilon):
		return MovementDirection.FORWARD
	
	return MovementDirection.NONE
	

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


func thrust_up(thrust : float) -> void:
	actual_thrust_vector.y = thrust
	
func thrust_down(thrust: float) -> void:
	actual_thrust_vector.y = -thrust

func thrust_forward(thrust: float) -> void:
	actual_thrust_vector.z = thrust

func thrust_backward(thrust: float) -> void:
	actual_thrust_vector.z = -thrust

func thrust_left(thrust: float) -> void:
	actual_thrust_vector.x = -thrust

func thrust_right(thrust: float) -> void:
	actual_thrust_vector.x = thrust

#===========================================================================#

func set_target_thrust_up(thrust : float) -> void:
	target_thrust_vector.y = thrust

func set_target_thrust_down(thrust : float) -> void:
	target_thrust_vector.y = -thrust
	
func set_target_thrust_left(thrust : float) -> void:
	target_thrust_vector.x = -thrust
	
func set_target_thrust_right(thrust : float) -> void:
	target_thrust_vector.x = thrust

func set_target_thrust_forward(thrust : float) -> void:
	target_thrust_vector.z = thrust

func set_target_thrust_backward(thrust : float) -> void:
	target_thrust_vector.z = -thrust
	
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

enum MovementDirection
{
	FORWARD,
	BACKWARD,
	UP,
	DOWN,
	LEFT,
	RIGHT,
	ROLL_LEFT,
	ROLL_RIGHT,
	YAW_LEFT,
	YAW_RIGHT,
	PITCH_UP,
	PITCH_DOWN,
	NONE
}
