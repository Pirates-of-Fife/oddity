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
var pid_forward : PIDController = $ShipPidControllers/PIDForward
@onready
var pid_backward : PIDController = $ShipPidControllers/PIDBackward
@onready
var pid_up : PIDController = $ShipPidControllers/PIDUp
@onready
var pid_down : PIDController = $ShipPidControllers/PIDDown
@onready
var pid_left : PIDController = $ShipPidControllers/PIDLeft
@onready
var pid_right : PIDController = $ShipPidControllers/PIDRight

@onready
var pid_roll_left : PIDController =  $ShipPidControllers/PIDRollLeft
@onready
var pid_roll_right : PIDController =  $ShipPidControllers/PIDRollRight
@onready
var pid_yaw_left : PIDController =  $ShipPidControllers/PIDYawLeft
@onready
var pid_yaw_right : PIDController =  $ShipPidControllers/PIDYawRight
@onready
var pid_pitch_up : PIDController =  $ShipPidControllers/PIDPitchUp
@onready
var pid_pitch_down : PIDController =  $ShipPidControllers/PIDPitchDown

var epsilon : float = 0.0001

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

@onready
var starship_travel_modes : StarshipTravelModes = StarshipTravelModes.new()

var travel_mode : StarshipTravelModes.TravelMode

@export_category("Modules")

@export_subgroup("Abyss")

@export
var abyss_drive_slot : AbyssalJumpDriveSlot

@export
var abyssal_portal_spawn_point : Marker3D

var abyssal_portal_active : bool
var current_abyss_portal : AbyssalPortal
var current_star_system : StarSystem
var selected_system : StarSystemResource

var is_in_abyss : bool = false

@export_subgroup("Super Cruise")

signal alcubierre_drive_removed
signal alcubierre_drive_inserted

@export
var alcubierre_drive_slot : AlcubierreDriveSlot

var alcubierre_drive_spool_time : float
var alcubierre_drive_accelleration : float
var alcubierre_drive_max_speed : float
var current_super_cruise_speed : float
var current_super_cruise_speed_in_c : float

signal super_cruise_engaged
signal super_cruise_disengaged


@export_category("Interaction")

@export
var interaction_length : float = 2.5

var raycast_helper : RaycastHelper = RaycastHelper.new()


@onready
var current_max_velocity : float = ship_info.max_linear_velocity

var lock_timer : Timer = Timer.new()

func _ready() -> void:
	_starship_ready()
	
func _starship_ready() -> void:
	_default_ready()

	travel_mode = starship_travel_modes.TravelMode.CRUISE

	lock_timer.one_shot = true
	lock_timer.wait_time = 0.5
	lock_timer.timeout.connect(lock_ship)

	add_child(lock_timer)

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
	
	alcubierre_drive_slot.module_removed.connect(on_alcubierre_drive_removed)
	alcubierre_drive_slot.module_inserted.connect(on_alcubierre_drive_inserted)
	
	if alcubierre_drive_slot.module != null:
		on_alcubierre_drive_inserted(alcubierre_drive_slot.module)
	
	current_star_system = get_tree().get_first_node_in_group("StarSystem")
	selected_system = get_tree().get_first_node_in_group("World").cycle_system()
	update_abyssal_mfd()


func on_alcubierre_drive_removed(alcubierre_drive : Module) -> void:
	alcubierre_drive_removed.emit(alcubierre_drive)
	
func on_alcubierre_drive_inserted(alcubierre_drive : Module) -> void:
	alcubierre_drive_inserted.emit(alcubierre_drive)


func cycle_selected_system() -> void:
	if is_in_abyss:
		return
	
	var world : World = get_tree().get_first_node_in_group("World")
	selected_system = world.cycle_system()
	update_abyssal_mfd()

func update_abyssal_mfd() -> void:
	pass

func lock_ship() -> void:
	if (abs(target_speed_vector.length() - local_linear_velocity.length()) < 0.7) and local_linear_velocity.length() < 1:
		axis_lock_linear_x = true
		axis_lock_linear_y = true
		axis_lock_linear_z = true
		
func toggle_landing_gear() -> void:
	pass

func initiate_abyssal_travel() -> void:
	if abyss_drive_slot.module == null:
		return
		
	if is_in_abyss:
		return
	
	if selected_system == null:
		return
		
	if travel_mode == StarshipTravelModes.TravelMode.SUPER_CRUISE:
		return
		
	if abyssal_portal_active:
		current_abyss_portal.close()
		current_abyss_portal = null
		abyssal_portal_active = false
		return
	
	var abyssal_portal_scene : PackedScene = preload("res://classes/abyss/abyssal-portal/AbyssalPortal.tscn")
	var abyssal_portal : AbyssalPortal = abyssal_portal_scene.instantiate()
	
	current_abyss_portal = abyssal_portal
	abyssal_portal_active = true
	
	get_tree().get_first_node_in_group("StarSystem").add_child(abyssal_portal)
	abyssal_portal.global_position = abyssal_portal_spawn_point.global_position
	abyssal_portal.global_rotation = abyssal_portal_spawn_point.global_rotation
	abyssal_portal.destination_star_system = selected_system.scene_file
	abyssal_portal.starship = self

func initiate_super_cruise() -> void:
	if alcubierre_drive_slot.module == null:
		return
	
	current_super_cruise_speed = 0
	travel_mode = StarshipTravelModes.TravelMode.SUPER_CRUISE
	
	freeze_mode = FREEZE_MODE_KINEMATIC
	freeze = true
	
	super_cruise_engaged.emit()

func exit_super_cruise() -> void:
	if current_super_cruise_speed > 50:
		return
	
	travel_mode =  StarshipTravelModes.TravelMode.CRUISE
	
	freeze = false
	collision_layer = 1 << 8
	collision_mask = 1 << 8
	
	super_cruise_disengaged.emit()

func cruise_travel(delta : float) -> void:
	calculate_local_linear_velocity()
	calculate_local_angular_velocity()
	calculate_acceleration(delta)
	
	if (abs(target_speed_vector.length() - local_linear_velocity.length()) < 0.7) and local_linear_velocity.length() < 1:
		if active_frame_of_reference is GravityGrid or active_frame_of_reference is GravityWell:
			if active_frame_of_reference.enable_gravity == true:
				if lock_timer.is_stopped():
					lock_timer.start()
	else:
		axis_lock_linear_x = false
		axis_lock_linear_y = false
		axis_lock_linear_z = false

	target_speed_vector = calculate_target_speed_vector()
	target_rotation_speed_vector = calculate_target_rotation_speed_vector()

	var velocity_delta : float = 0
	var thrust : float = 0

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

var last_position : Vector3 = Vector3.ZERO

func super_cruise_travel(delta : float) -> void:
	calculate_local_linear_velocity()
	calculate_local_angular_velocity()
	calculate_acceleration(delta)
	
	var target_velocity : float = target_thrust_vector.z * alcubierre_drive_slot.module.module_resource.max_speed
	
	var velocity_diff : float = abs(current_super_cruise_speed - target_velocity)
	var acceleration_scale : float = lerpf(0, 1, velocity_diff / 3000)
	
	
	
	if current_super_cruise_speed > target_velocity:
		current_super_cruise_speed -= alcubierre_drive_slot.module.module_resource.deacceleration * acceleration_scale
	if current_super_cruise_speed < target_velocity:
		current_super_cruise_speed += alcubierre_drive_slot.module.module_resource.acceleration * acceleration_scale
	
	
	current_super_cruise_speed = clampf(current_super_cruise_speed, 0, alcubierre_drive_slot.module.module_resource.max_speed)
	
	global_position += global_transform.basis.z * current_super_cruise_speed
	
	#print("dif: " + str(velocity_diff) + " scale: " + str(acceleration_scale) + " aceel: " + str( alcubierre_drive_slot.module.module_resource.acceleration * acceleration_scale ) + " deaceel: " + str( alcubierre_drive_slot.module.module_resource.deacceleration * acceleration_scale ) + " speed: " + str(current_super_cruise_speed))
	current_super_cruise_speed_in_c = ((((global_position - last_position) / delta) / 299_792_458.0) * 1000).length()
		
	last_position = global_position
	
	#print(target_rotational_thrust_vector)
	
	rotate_object_local(Vector3(1, 0, 0), target_rotational_thrust_vector.x * alcubierre_drive_slot.module.module_resource.max_turn_speed)
	rotate_object_local(Vector3(0, 1, 0), target_rotational_thrust_vector.y * alcubierre_drive_slot.module.module_resource.max_turn_speed)
	rotate_object_local(Vector3(0, 0, 1), target_rotational_thrust_vector.z * alcubierre_drive_slot.module.module_resource.max_turn_speed)


	
	
func _physics_process(delta: float) -> void:
	_default_physics_process(delta)
	
	if active_control_seat != null and freeze == true:
		unfreeze()
	
	if travel_mode == starship_travel_modes.TravelMode.CRUISE or travel_mode == starship_travel_modes.TravelMode.ABYSSAL_TRAVEL:
		cruise_travel(delta)
	elif travel_mode == starship_travel_modes.TravelMode.SUPER_CRUISE:
		super_cruise_travel(delta)
	
	
	update_ui()

	# reset thrust vector
	reset_thrust_vectors()

	relative_gravity_vector = Vector3.ZERO

func update_ui() -> void:
	pass

func increase_max_velocity(velocity : float) -> void:
	if current_max_velocity + velocity > ship_info.max_linear_velocity:
		current_max_velocity = ship_info.max_linear_velocity
		return

	current_max_velocity += velocity

func decrease_max_velocity(velocity : float) -> void:
	if current_max_velocity - velocity < 0:
		current_max_velocity = 0
		return

	current_max_velocity -= velocity

func use_interact() -> void:
	var result : Dictionary = raycast_helper.cast_raycast_from_node(anchor, interaction_length)

	if result.size() > 0:
		var collider : Object = result["collider"]

		if collider is Interactable:
			collider.interact(player, self)

func reset_thrust_vectors() -> void:
	target_thrust_vector = Vector3.ZERO
	target_rotational_thrust_vector = Vector3.ZERO

func calculate_acceleration(delta : float) -> void:
	acceleration = (snapped(local_linear_velocity, Vector3(0.1, 0.1, 0.1)) - snapped(local_linear_velocity_last_frame, Vector3(0.1, 0.1, 0.1))) / delta
	local_linear_velocity_last_frame = local_linear_velocity

func calculate_local_linear_velocity() -> void:
	local_linear_velocity = transform.basis.inverse() * relative_linear_velocity

func calculate_local_angular_velocity() -> void:
	local_angular_velocity = transform.basis.inverse() * angular_velocity

func calculate_target_speed_vector() -> Vector3:		
	return target_thrust_vector * current_max_velocity

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
