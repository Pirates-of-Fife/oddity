extends RigidBody3D

var velocity : Vector3
var local_angular_velocity : Vector3
var velocity_last_frame : Vector3
var acceleration : Vector3

var dry_weight : float

signal output_velocity(velocity : Vector3)
signal output_acceleration(acceleration : Vector3)
signal output_local_angular_velocity(local_angular_velocity : Vector3)

func _ready():
	dry_weight = mass

func _process(delta):
	calc_accelleration()
	calc_local_velocity()
	calc_local_angular_velocity()

	output_acceleration.emit(acceleration)
	output_velocity.emit(velocity)
	output_local_angular_velocity.emit(local_angular_velocity)
	
	mass = dry_weight + %"Components/Fuel Tanks".current_fuel_capacity * 0.00013
	#print(massw)
	
func calc_accelleration():
	acceleration = (snapped(velocity, Vector3(0.1, 0.1, 0.1)) - snapped(velocity_last_frame, Vector3(0.1, 0.1, 0.1))) / get_process_delta_time();
	velocity_last_frame = velocity

func calc_local_velocity():
	velocity = transform.basis.inverse() * linear_velocity

func calc_local_angular_velocity():
	local_angular_velocity = transform.basis.inverse() * angular_velocity

func _on_simple_flight_control_system_output_thrust_vector(thrust_vector):
	if (%"Components/Fuel Tanks".current_fuel_capacity > 0 and %Thrusters.recieved_power == %Thrusters.required_power):
		apply_central_force(thrust_vector * global_basis.inverse() * %"Components/Fuel Tanks".current_active_fuel_tank.fuel_power) 

func _on_simple_flight_control_system_output_torque_vector(torque_vector):
	if (%"Components/Fuel Tanks".current_fuel_capacity > 0 and %Thrusters.recieved_power == %Thrusters.required_power):
		apply_torque(torque_vector * global_basis.inverse() * %"Components/Fuel Tanks".current_active_fuel_tank.fuel_power)

func calculate_fuel_consumption_thrust(thrust_vector : Vector3) -> float:
	var fuel_consumption = 0.0
	
	if (thrust_vector.z > 0):
		fuel_consumption += %Thrusters.retro_thrust_fuel_consumption * thrust_vector.z
	else:
		fuel_consumption += %Thrusters.main_thrust_fuel_consumption * -thrust_vector.z

	if (thrust_vector.x > 0):
		fuel_consumption += %Thrusters.left_thrust_fuel_consumption * thrust_vector.x
	else:
		fuel_consumption += %Thrusters.right_thrust_fuel_consumption * -thrust_vector.x

	if (thrust_vector.y > 0):
		fuel_consumption += %Thrusters.bottom_thrust_fuel_consumption * thrust_vector.y
	else:
		fuel_consumption += %Thrusters.top_thrust_fuel_consumption * -thrust_vector.y
	
	return snappedf(fuel_consumption, 0.1) * (1.0 / %"Components/Fuel Tanks".current_active_fuel_tank.fuel_efficiency)

func calculate_fuel_consumption_torque(torque_vector : Vector3) -> float:
	var fuel_consumption = 0.0

	if (torque_vector.z > 0):
		fuel_consumption += %Thrusters.roll_right_thrust_fuel_consumption * torque_vector.z
	else:
		fuel_consumption += %Thrusters.roll_left_thrust_fuel_consumption * -torque_vector.z

	if (torque_vector.x > 0):
		fuel_consumption += %Thrusters.pitch_up_thrust_fuel_consumption * -torque_vector.z
	else:
		fuel_consumption += %Thrusters.pitch_down_thrust_fuel_consumption * torque_vector.z

	if (torque_vector.y > 0):
		fuel_consumption += %Thrusters.yaw_right_thrust_fuel_consumption * torque_vector.y
	else:
		fuel_consumption += %Thrusters.yaw_left_thrust_fuel_consumption * -torque_vector.y

	return snappedf(fuel_consumption, 0.1) * (1.0 / %"Components/Fuel Tanks".current_active_fuel_tank.fuel_efficiency)


func _on_simple_flight_control_system_output_unit_thrust_vector(thrust_vector):
	if (%Thrusters.recieved_power == %Thrusters.required_power):
		%"Components/Fuel Tanks".use_fuel(calculate_fuel_consumption_thrust(thrust_vector))

func _on_simple_flight_control_system_output_unit_torque_vector(torque_vector):
	if (%Thrusters.recieved_power == %Thrusters.required_power):
		%"Components/Fuel Tanks".use_fuel(calculate_fuel_consumption_torque(torque_vector)) 
