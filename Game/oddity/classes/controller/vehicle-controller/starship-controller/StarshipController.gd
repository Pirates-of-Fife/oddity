extends VehicleController

class_name StarshipController

var starship_pitch_down_command : StarshipPitchDownCommand = StarshipPitchDownCommand.new()
var starship_pitch_up_command : StarshipPitchUpCommand = StarshipPitchUpCommand.new()
var starship_roll_left_command : StarshipRollLeftCommand = StarshipRollLeftCommand.new()
var starship_roll_right_command : StarshipRollRightCommand = StarshipRollRightCommand.new()
var starship_yaw_left_command : StarshipYawLeftCommand = StarshipYawLeftCommand.new()
var starship_yaw_right_command : StarshipYawRightCommand = StarshipYawRightCommand.new()

var starship_thrust_forward_command : StarshipThrustForwardCommand = StarshipThrustForwardCommand.new()
var starship_thrust_backward_command : StarshipThrustBackwardCommand = StarshipThrustBackwardCommand.new()
var starship_thrust_left_command : StarshipThrustLeftCommand = StarshipThrustLeftCommand.new()
var starship_thrust_right_command : StarshipThrustRightCommand = StarshipThrustRightCommand.new()
var starship_thrust_up_command : StarshipThrustUpCommand = StarshipThrustUpCommand.new()
var starship_thrust_down_command : StarshipThrustDownCommand = StarshipThrustDownCommand.new()

var starship_player_interact_command : StarshipPlayerInteractCommand = StarshipPlayerInteractCommand.new()

var starship_toggle_landing_gear_command : StarshipToggleLandingGearCommand = StarshipToggleLandingGearCommand.new()

var starship_increase_max_velocity_command : StarshipIncreaseMaxVelocityCommand = StarshipIncreaseMaxVelocityCommand.new()
var starship_decrease_max_velocity_command : StarshipDecreaseMaxVelocityCommand = StarshipDecreaseMaxVelocityCommand.new()

var starship_initiate_abyssal_travel_command : StarshipInitiateAbyssalTravelCommand = StarshipInitiateAbyssalTravelCommand.new()
var starship_initiate_super_cruise_command : StarshipInitiateSuperCruiseCommand =StarshipInitiateSuperCruiseCommand.new()

var starship_cycle_system_command : StarshipCycleSelectedSystemCommand = StarshipCycleSelectedSystemCommand.new()

var starship_shoot_primary_command : StarshipShootPrimaryCommand = StarshipShootPrimaryCommand.new()
var starship_shoot_secondary_command : StarshipShootSecondaryCommand = StarshipShootSecondaryCommand.new()
var starship_shoot_tertiary_command : StarshipShootTertiaryCommand = StarshipShootTertiaryCommand.new()

var starship_stop_shooting_primary_command : StarshipStopShootingPrimaryCommand = StarshipStopShootingPrimaryCommand.new()
var starship_stop_shooting_secondary_command : StarshipStopShootingSecondaryCommand = StarshipStopShootingSecondaryCommand.new()
var starship_stop_shooting_tertiary_command : StarshipStopShootingTertiaryCommand = StarshipStopShootingTertiaryCommand.new()

var starship_cycle_power_state_command : StarshipCyclePowerStateCommand = StarshipCyclePowerStateCommand.new()

var starship_focus_target_command : StarshipFocusTargetCommand = StarshipFocusTargetCommand.new()

var starship_toggle_headlights_command : StarshipToggleHeadlightsCommand = StarshipToggleHeadlightsCommand.new()

var starship_last_throttle_value : float = 0
var current_throttle_forwards_axis : float = 0

@export_category("Control Settings")

@export
var mouse_joystick_deadzone : float = 0.04

@export
var ship_mouse_controls_sensitivity : float = Globals.starship_controller_sensitity

@export
var look_around_sensitivity : float = Globals.creature_controller_sensitivity

@export
var keyboard_throttle_sensitivity : float = 0.8

@export
var velocity_change_on_scroll : float = 40

@export
var keyboard_throttle_deadzone : float = 0.05

var mouse_yaw : float = 0.0
var mouse_pitch : float = 0.0

@onready
var throttle_deadzone_reset_timer : Timer = Timer.new()

@onready
var supercruise_initialization_timer : Timer = Timer.new()

@onready
var supercruise_exit_timer : Timer = Timer.new()

var starship_ready_to_supercruise : bool = true
var starship_has_alcubierre_drive : bool

func _ready() -> void:
	_starship_controller_ready()

func _starship_controller_ready() -> void:
	_vehicle_ready()

	add_child(throttle_deadzone_reset_timer)
	add_child(supercruise_initialization_timer)
	add_child(supercruise_exit_timer)

	throttle_deadzone_reset_timer.wait_time = 0.4
	throttle_deadzone_reset_timer.one_shot = true
	throttle_deadzone_reset_timer.timeout.connect(_on_throttle_deadzone_reset_timer_timeout)

	on_alcubierre_drive_inserted(control_entity.alcubierre_drive_slot.module)
	supercruise_initialization_timer.one_shot = true
	supercruise_initialization_timer.timeout.connect(_on_supercruise_initialization_timer_timeout)


	supercruise_exit_timer.wait_time = 1
	supercruise_exit_timer.one_shot = true
	supercruise_exit_timer.timeout.connect(_on_supercruise_exit_timer_timeout)

	if control_entity is Starship:
		control_entity.alcubierre_drive_inserted.connect(on_alcubierre_drive_inserted)
		control_entity.alcubierre_drive_removed.connect(on_alcubierre_drive_removed)

func _process(delta: float) -> void:
	_starship_controller_process(delta)

func on_alcubierre_drive_removed(alcubierre_drive : Module) -> void:
	starship_has_alcubierre_drive = false

func on_alcubierre_drive_inserted(alcubierre_drive : Module) -> void:
	if alcubierre_drive == null:
		return
	starship_has_alcubierre_drive = true
	supercruise_initialization_timer.wait_time = (alcubierre_drive as AlcubierreDrive).module_resource.spool_time

func _on_supercruise_exit_timer_timeout() -> void:
	starship_ready_to_supercruise = true

func _starship_controller_process(delta : float) -> void:
	if control_entity is Starship:

		if (Input.is_action_just_pressed("player_interact")):
			starship_player_interact_command.execute(control_entity)
		
		if (Input.is_key_label_pressed(KEY_0)):
			control_entity.global_position = Vector3(-36114200, 170000, -3963060)
		
		if (Input.is_action_just_pressed("vehicle_exit_seat")):
			if control_entity.relative_linear_velocity.length() < 10 and control_entity.is_in_abyss == false and control_entity.travel_mode != StarshipTravelModes.TravelMode.SUPER_CRUISE:
				vehicle_exit_seat_command.execute(control_entity)

				if control_entity is RABS_KestrelMk1:
					control_entity.show_interior()

		if (Input.is_action_just_pressed("starship_cycle_power_state")):
			starship_cycle_power_state_command.execute(control_entity)

		if (Input.is_action_just_pressed("general_third_person")):
			general_toggle_third_person_command.execute(control_entity)
			third_person = !third_person

		if (Input.is_action_just_pressed("general_toogle_look_around")):
			mouse_yaw = 0
			mouse_pitch = 0
			general_toggle_look_around_command.execute(control_entity)
			look_around = !look_around

		if look_around:
			if control_entity.active_control_seat != null:
				control_entity.active_control_seat.control_seat_anchor.look(mouse_yaw, mouse_pitch)

			if (Input.is_action_just_pressed("general_third_person_increase_distance")):
				general_increase_third_person_distance_command.execute(control_entity)

			if (Input.is_action_just_pressed("general_third_person_decrease_distance")):
				general_decrease_third_person_distance_command.execute(control_entity)

			mouse_yaw = 0
			mouse_pitch = 0
		else:
			if !third_person:
				if control_entity.active_control_seat != null:
					control_entity.active_control_seat.control_seat_anchor.reset()

		if !control_entity.is_powered_on():
			return

		if (Input.is_action_just_pressed("ship_toggle_headlights")):
			starship_toggle_headlights_command.execute(control_entity)

		current_throttle_forwards_axis = starship_last_throttle_value #control_entity.target_thrust_vector.z

		if (Input.is_action_pressed("starship_throttle_forward")):
			current_throttle_forwards_axis -= keyboard_throttle_sensitivity * delta

		if (Input.is_action_pressed("starship_throttle_backward")):
			current_throttle_forwards_axis += keyboard_throttle_sensitivity * delta

		if control_entity.is_in_abyss or control_entity.travel_mode == (StarshipTravelModes.TravelMode.SUPER_CRUISE):
			if current_throttle_forwards_axis > 0:
				current_throttle_forwards_axis = 0

		current_throttle_forwards_axis = clampf(current_throttle_forwards_axis, -1, 1)

		starship_last_throttle_value = current_throttle_forwards_axis

		if (current_throttle_forwards_axis <= 0):
			starship_thrust_forward_command.execute(control_entity, StarshipThrustForwardCommand.Params.new(-current_throttle_forwards_axis))
		else:
			starship_thrust_backward_command.execute(control_entity, StarshipThrustBackwardCommand.Params.new(current_throttle_forwards_axis))

		if (abs(current_throttle_forwards_axis) < keyboard_throttle_deadzone and current_throttle_forwards_axis != 0):
			if (throttle_deadzone_reset_timer.is_stopped()):
				throttle_deadzone_reset_timer.start()

		if (Input.is_action_pressed("starship_throttle_left")):
			starship_thrust_left_command.execute(control_entity, StarshipThrustLeftCommand.Params.new(Input.get_action_strength("starship_throttle_left")))

		if (Input.is_action_pressed("starship_throttle_right")):
			starship_thrust_right_command.execute(control_entity, StarshipThrustRightCommand.Params.new(Input.get_action_strength("starship_throttle_right")))

		if (Input.is_action_pressed("starship_throttle_up")):
			starship_thrust_up_command.execute(control_entity, StarshipThrustUpCommand.Params.new(Input.get_action_strength("starship_throttle_up")))

		if (Input.is_action_pressed("starship_throttle_down")):
			starship_thrust_down_command.execute(control_entity, StarshipThrustDownCommand.Params.new(Input.get_action_strength("starship_throttle_down")))

		if (Input.is_action_pressed("starship_rotate_roll_left")):
			starship_roll_left_command.execute(control_entity, StarshipRollLeftCommand.Params.new(Input.get_action_strength("starship_rotate_roll_left")))

		if (Input.is_action_pressed("starship_rotate_roll_right")):
			starship_roll_right_command.execute(control_entity, StarshipRollRightCommand.Params.new(Input.get_action_strength("starship_rotate_roll_right")))

		# Starship Mouse Pitch

		if !look_around:
			var deadzoned_yaw : float = mouse_yaw
			var deazoned_pitch : float = mouse_pitch

			if abs(mouse_yaw) < mouse_joystick_deadzone:
				deadzoned_yaw = 0

			if abs(mouse_pitch) < mouse_joystick_deadzone:
				deazoned_pitch = 0

			if (mouse_pitch > 0):
				starship_pitch_up_command.execute(control_entity, StarshipPitchUpCommand.Params.new(abs(deazoned_pitch)))
			else:
				starship_pitch_down_command.execute(control_entity, StarshipPitchDownCommand.Params.new(abs(deazoned_pitch)))

			# Starship Mouse Yaw

			if (mouse_yaw > 0):
				starship_yaw_left_command.execute(control_entity, StarshipYawLeftCommand.Params.new(abs(deadzoned_yaw)))
			else:
				starship_yaw_right_command.execute(control_entity, StarshipYawRightCommand.Params.new(abs(deadzoned_yaw)))

			if (Input.is_action_just_pressed("starship_increase_max_velocity")):
				starship_increase_max_velocity_command.execute(control_entity, StarshipIncreaseMaxVelocityCommand.Params.new(velocity_change_on_scroll))

			if (Input.is_action_just_pressed("starship_decrease_max_velocity")):
				starship_decrease_max_velocity_command.execute(control_entity, StarshipDecreaseMaxVelocityCommand.Params.new(velocity_change_on_scroll))

		if (Input.is_action_just_pressed("starship_toggle_landing_gear")):
			starship_toggle_landing_gear_command.execute(control_entity)

		if (Input.is_action_just_pressed("starship_abyssal_travel")):
			starship_initiate_abyssal_travel_command.execute(control_entity)

		if (Input.is_action_just_pressed("starship_cycle_selected_system")):
			starship_cycle_system_command.execute(control_entity)

		if (Input.is_action_just_pressed("starship_initiate_super_cruise")):
			if control_entity.is_in_abyss:
				return

			if control_entity.is_mass_locked:
				return

			if control_entity.travel_mode == StarshipTravelModes.TravelMode.SUPER_CRUISE:
				control_entity.exit_super_cruise()
				supercruise_exit_timer.start()
			else:
				if starship_ready_to_supercruise:
					supercruise_initialization_timer.start()
					control_entity.alcubierre_drive_charge_start()

		if (Input.is_action_just_released("starship_initiate_super_cruise")):
			print("WORK")
			
			if control_entity.travel_mode == StarshipTravelModes.TravelMode.SUPER_CRUISE:
				return
			
			print("super")
			
			if control_entity.is_in_abyss:
				return
			
			print("abyss")
			
			print(starship_ready_to_supercruise)
			
			if starship_ready_to_supercruise:
				supercruise_initialization_timer.stop()
				control_entity.alcubierre_drive_charge_end()

		if (Input.is_action_pressed("starship_shoot_primary_weapons")):
			starship_shoot_primary_command.execute(control_entity)

		if (Input.is_action_pressed("starship_shoot_secondary_weapons")):
			starship_shoot_secondary_command.execute(control_entity)

		if (Input.is_action_pressed("starship_shoot_tertiary_weapons")):
			starship_shoot_tertiary_command.execute(control_entity)

		if (Input.is_action_just_released("starship_shoot_primary_weapons")):
			starship_stop_shooting_primary_command.execute(control_entity)

		if (Input.is_action_just_released("starship_shoot_secondary_weapons")):
			starship_stop_shooting_secondary_command.execute(control_entity)

		if (Input.is_action_just_released("starship_shoot_tertiary_weapons")):
			starship_stop_shooting_tertiary_command.execute(control_entity)

		if (Input.is_action_just_released("starship_focus_target")):
			starship_focus_target_command.execute(control_entity)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if look_around:
				mouse_yaw = - event.relative.x * look_around_sensitivity
				mouse_pitch = - event.relative.y * look_around_sensitivity
			else:
				mouse_yaw += lerp(0,1,clamp(event.relative.x * get_process_delta_time(),-1,1)) * ship_mouse_controls_sensitivity
				mouse_pitch += lerp(0,1,clamp(event.relative.y * get_process_delta_time(),-1,1)) * ship_mouse_controls_sensitivity

				mouse_yaw = clamp(mouse_yaw, -1, 1)
				mouse_pitch = clamp(mouse_pitch, -1, 1)

func _on_throttle_deadzone_reset_timer_timeout() -> void:
	if (abs(current_throttle_forwards_axis) < keyboard_throttle_deadzone):
		if (control_entity is Starship):
			starship_thrust_forward_command.execute(control_entity, StarshipThrustForwardCommand.Params.new(0))
			current_throttle_forwards_axis = 0
			starship_last_throttle_value = 0

func _on_supercruise_initialization_timer_timeout() -> void:
	if control_entity is Starship:
		starship_ready_to_supercruise = false
		control_entity.initiate_super_cruise()
