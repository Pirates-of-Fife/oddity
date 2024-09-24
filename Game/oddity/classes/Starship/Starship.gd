# @class Vehicle
# Base Class for all Starships

extends Vehicle

class_name Starship

@export_category("Target Thrust Vector")

@export
var target_thrust_vector : Vector3 = Vector3.ZERO

@export
var target_rotational_thrust_vector : Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	print(target_thrust_vector)
	
	# reset thrust vector
	
	target_thrust_vector = Vector3.ZERO

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
