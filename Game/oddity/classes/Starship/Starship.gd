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

# Placeholder

@export
var max_thrust : float

@export
var max_rotation_thrust : float

@onready
var pid_controller : PIDController = PIDController.new(15, 0.1, 0.01, 0.001, 0, max_thrust)

func _physics_process(delta: float) -> void:
	#print("Target Thurst: " + str(target_thrust_vector))
	#print("Target Rotation: " + str(target_rotational_thrust_vector))
	
	var target_speed_vector : Vector3 = calculate_target_speed_vector()
	var target_rotation_speed_vector : Vector3 = calculate_target_rotation_speed_vector()
		
	var forwards_thrust : float = pid_controller.update(-target_speed_vector.z, abs(linear_velocity.z), delta)
		
	print(linear_velocity)
	
	apply_central_force(Vector3(0,0, forwards_thrust))
	
	# reset thrust vector
	reset_thrust_vectors()

func reset_thrust_vectors() -> void:
	target_thrust_vector = Vector3.ZERO
	target_rotational_thrust_vector = Vector3.ZERO

func flight_calculations() -> void:
	#pid_controller.update()
	pass
	
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
