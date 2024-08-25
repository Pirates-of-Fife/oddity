extends "res://Scenes/Spaceship/Common/Interfaces/I_PoweredComponent.gd"

@onready
var ship_stats = %ShipStats

@onready
var main_thrusters = %Thrusters.main_thrusters

@onready
var retro_thrusters = %Thrusters.retro_thrusters

@onready
var left_thrusters = %Thrusters.left_thrusters

@onready
var right_thrusters = %Thrusters.right_thrusters

@onready
var top_thrusters = %Thrusters.top_thrusters

@onready
var bottom_thrusters = %Thrusters.bottom_thrusters

@onready
var roll_right_thrusters = %Thrusters.roll_right_thrusters

@onready
var roll_left_thrusters = %Thrusters.roll_left_thrusters

@onready
var pitch_up_thrusters = %Thrusters.pitch_up_thrusters

@onready
var pitch_down_thrusters = %Thrusters.pitch_down_thrusters

@onready
var yaw_right_thrusters = %Thrusters.yaw_right_thrusters

@onready
var yaw_left_thrusters = %Thrusters.yaw_left_thrusters

@export_category("Flight Control Settings")

@export
var flight_assist : bool

@export
var rotational_assist : bool

@export
var anti_gravity_system : bool

var movement_vector : Vector3
var rotation_vector : Vector3

var velocity : Vector3
var acceleration : Vector3
var local_angular_velocity : Vector3

signal output_thrust_vector(thrust_vector : Vector3)
signal output_torque_vector(torque_vector : Vector3)

signal output_unit_thrust_vector(thrust_vector : Vector3)
signal output_unit_torque_vector(torque_vector : Vector3)

var thrust_vector : Vector3
var torque_vector : Vector3

var unit_thrust_vector : Vector3
var unit_torque_vector : Vector3

var output_thrusters : Dictionary

@export
var max_velocity : float

@export
var max_pitch_velocity : float

@export
var max_yaw_velocity : float

@export
var max_roll_velocity : float

@export
var controller_curve : Curve

@export
var rotation_control_curve : Curve

@export_category("Component Information")

# Called when the node enters the scene tree for the first time.
func _ready():
	power_priority = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	thrust_vector = Vector3.ZERO
	torque_vector = Vector3.ZERO
	unit_thrust_vector = Vector3.ZERO
	unit_torque_vector = Vector3.ZERO
	
	#print("velocity: " + str(velocity))
	
	var desired_velocity = 0
	var velocity_delta = 0
	var desired_thrust = 0
	
	if (flight_assist and recieved_power == required_power):
		
		## LATERAL
		
		desired_velocity = calculate_desired_velocity(movement_vector.x)
		velocity_delta = calculate_velocity_delta(velocity.x, desired_velocity)
		desired_thrust = calculate_desired_thrust(velocity_delta)
		
		if (velocity_delta > 0):
			move_ship_left(desired_thrust)
		elif (velocity_delta < 0):
			move_ship_right(desired_thrust)
		
		## FORWARDS
		
		desired_velocity = calculate_desired_velocity(movement_vector.z)
		velocity_delta = calculate_velocity_delta(velocity.z, desired_velocity)
		desired_thrust = calculate_desired_thrust(velocity_delta)
		
		if (velocity_delta > 0):
			move_ship_forward(desired_thrust)
		elif (velocity_delta < 0):
			move_ship_backward(desired_thrust)

		## VERTICAL

		desired_velocity = calculate_desired_velocity(movement_vector.y)
		velocity_delta = calculate_velocity_delta(velocity.y, desired_velocity)
		desired_thrust = calculate_desired_thrust(velocity_delta)
		
		if (velocity_delta < 0):
			move_ship_up(desired_thrust)
		elif (velocity_delta > 0):
			move_ship_down(desired_thrust)
	
	else:
		if (movement_vector.x > 0):
			move_ship_right(abs(movement_vector.x))
		else:
			move_ship_left(abs(movement_vector.x))
	
		if (movement_vector.z > 0):
			move_ship_backward(abs(movement_vector.z))
		else:
			move_ship_forward(abs(movement_vector.z))
	
		if (movement_vector.y > 0):
			move_ship_up(abs(movement_vector.y))
		else:
			move_ship_down(abs(movement_vector.y))
	
	if (rotational_assist):
		
		## YAW
		
		desired_velocity = calculate_desired_angular_velocity(rotation_vector.y, max_yaw_velocity)
		velocity_delta = calculate_velocity_delta(-local_angular_velocity.y, desired_velocity)
		desired_thrust = calculate_desired_torque(velocity_delta, max_yaw_velocity)
		
		if (velocity_delta > 0):
			yaw_ship_left(desired_thrust)
		elif (velocity_delta < 0):
			yaw_ship_right(desired_thrust)
		
		## PITCH
		
		desired_velocity = calculate_desired_angular_velocity(rotation_vector.x, max_pitch_velocity)
		velocity_delta = calculate_velocity_delta(-local_angular_velocity.x, desired_velocity)
		desired_thrust = calculate_desired_torque(velocity_delta, max_pitch_velocity)
		
		if (velocity_delta > 0):
			pitch_ship_up(desired_thrust)
		elif (velocity_delta < 0):
			pitch_ship_down(desired_thrust)	
		
		## ROLL
		
		desired_velocity = calculate_desired_angular_velocity(-rotation_vector.z, max_roll_velocity)
		velocity_delta = calculate_velocity_delta(local_angular_velocity.z, desired_velocity)
		desired_thrust = calculate_desired_torque(velocity_delta, max_roll_velocity)
		
		if (velocity_delta > 0):
			roll_ship_left(desired_thrust)
		elif (velocity_delta < 0):
			roll_ship_right(desired_thrust)
	else:
		if (rotation_vector.x < 0):
			pitch_ship_up(abs(rotation_vector.x))
		else:
			pitch_ship_down(abs(rotation_vector.x))
	
		if (rotation_vector.z > 0):
			roll_ship_left(abs(rotation_vector.z))
		else:
			roll_ship_right(abs(rotation_vector.z))
	
		if (rotation_vector.y < 0):
			yaw_ship_left(abs(rotation_vector.y))
		else:
			yaw_ship_right(abs(rotation_vector.y))

	if (%"Components/Fuel Tanks".current_fuel_capacity > 0 and %Thrusters.recieved_power == %Thrusters.required_power):
		%ThrusterAnimationTree.set("parameters/Pitch/Blend3/blend_amount", -unit_torque_vector.x )
		%ThrusterAnimationTree.set("parameters/Vertical/Blend3/blend_amount", -unit_thrust_vector.y)
		%ThrusterAnimationTree.set("parameters/Forwards/Blend3/blend_amount", unit_thrust_vector.z)
		%ThrusterAnimationTree.set("parameters/Lateral/Blend3/blend_amount", unit_thrust_vector.x)
		%ThrusterAnimationTree.set("parameters/Yaw/Blend3/blend_amount", -unit_torque_vector.y)
		%ThrusterAnimationTree.set("parameters/Roll/Blend3/blend_amount", -unit_torque_vector.z)
	else:
		%ThrusterAnimationTree.set("parameters/Pitch/Blend3/blend_amount", 0)
		%ThrusterAnimationTree.set("parameters/Vertical/Blend3/blend_amount", 0)
		%ThrusterAnimationTree.set("parameters/Forwards/Blend3/blend_amount", 0)
		%ThrusterAnimationTree.set("parameters/Lateral/Blend3/blend_amount", 0)
		%ThrusterAnimationTree.set("parameters/Yaw/Blend3/blend_amount", 0)
		%ThrusterAnimationTree.set("parameters/Roll/Blend3/blend_amount", 0)
	
	output_thrust_vector.emit(thrust_vector)
	output_torque_vector.emit(torque_vector)
	output_unit_thrust_vector.emit(unit_thrust_vector)
	output_unit_torque_vector.emit(unit_torque_vector)

func move_ship_left(thrust_percentage : float):
	thrust_vector.x = %Thrusters.right_thrust_force * -thrust_percentage
	unit_thrust_vector.x = -thrust_percentage
	
func move_ship_right(thrust_percentage : float):
	thrust_vector.x = %Thrusters.left_thrust_force * thrust_percentage
	unit_thrust_vector.x = thrust_percentage

func move_ship_forward(thrust_percentage : float):
	thrust_vector.z = %Thrusters.main_thrust_force * -thrust_percentage
	unit_thrust_vector.z = -thrust_percentage
	
func move_ship_backward(thrust_percentage : float):
	thrust_vector.z = %Thrusters.retro_thrust_force * thrust_percentage
	unit_thrust_vector.z = thrust_percentage

func move_ship_up(thrust_percentage : float):
	thrust_vector.y = %Thrusters.bottom_thrust_force * thrust_percentage
	unit_thrust_vector.y = thrust_percentage

func move_ship_down(thrust_percentage : float):
	thrust_vector.y = %Thrusters.top_thrust_force * -thrust_percentage
	unit_thrust_vector.y = -thrust_percentage

func roll_ship_right(thrust_percentage : float):
	torque_vector.z = %Thrusters.roll_right_thrust_force * thrust_percentage
	unit_torque_vector.z = thrust_percentage
	
func roll_ship_left(thrust_percentage : float):
	torque_vector.z = %Thrusters.roll_left_thrust_force * -thrust_percentage
	unit_torque_vector.z = -thrust_percentage

func pitch_ship_up(thrust_percentage : float):
	torque_vector.x = %Thrusters.pitch_down_thrust_force * thrust_percentage
	unit_torque_vector.x = thrust_percentage

func pitch_ship_down(thrust_percentage : float):
	torque_vector.x = %Thrusters.pitch_up_thrust_force * -thrust_percentage
	unit_torque_vector.x = -thrust_percentage

func yaw_ship_right(thrust_percentage : float):
	torque_vector.y = %Thrusters.yaw_left_thrust_force * -thrust_percentage
	unit_torque_vector.y = -thrust_percentage

func yaw_ship_left(thrust_percentage : float):
	torque_vector.y = %Thrusters.yaw_right_thrust_force * thrust_percentage
	unit_torque_vector.y = thrust_percentage

func calculate_desired_velocity(percentage : float) -> float:
	return percentage * max_velocity

func calculate_desired_angular_velocity(percentage : float, max_angular_velocity : float) -> float:
	return percentage * max_angular_velocity;

func calculate_velocity_delta(base_velocity : float, desired_velocity : float) -> float:
	return base_velocity - desired_velocity

func calculate_desired_thrust(velocity_delta : float) -> float:
	var normalized_velocity_delta = clamp(abs(velocity_delta) / max_velocity, 0.0, 1.0)

	var thrust = controller_curve.sample(normalized_velocity_delta)
	
	return clamp(thrust, 0.0, 1.0)

func calculate_desired_torque(velocity_delta : float, max_angular_velocity : float) -> float:
	var normalized_velocity_delta = clamp(abs(velocity_delta) / max_angular_velocity, 0.0, 1.0)

	var thrust = rotation_control_curve.sample(normalized_velocity_delta)
	
	return clamp(thrust, 0.0, 1.0)

func request_power():
	%"Components/Power Components".request_power(self)

func _on_player_input_send_movement_vector(movement_vector):
	self.movement_vector = movement_vector


func _on_player_input_send_rotation_vector(rotation_vector):
	self.rotation_vector = rotation_vector


func _on_fighter_gen_7_output_acceleration(acceleration):
	self.acceleration = acceleration


func _on_fighter_gen_7_output_velocity(velocity):
	self.velocity = velocity


func _on_fighter_gen_7_output_local_angular_velocity(local_angular_velocity):
	self.local_angular_velocity = local_angular_velocity

func recieve_power(power : float):
	recieved_power = power
