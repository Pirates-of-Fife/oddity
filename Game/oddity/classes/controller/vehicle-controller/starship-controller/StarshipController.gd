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


var starship_last_throttle_value : float = 0
var current_throttle_forwards_axis : float = 0

@export_category("Control Settings")

@export
var mouse_joystick_deadzone : float = 0.04

@export
var ship_mouse_controls_sensitivity : float = 0.1

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

var starship_has_alcubierre_drive : bool

func _ready() -> void:
	_starship_controller_ready()

func _starship_controller_ready() -> void:
	_vehicle_ready()

	add_child(throttle_deadzone_reset_timer)
	add_child(supercruise_initialization_timer)

	throttle_deadzone_reset_timer.wait_time = 0.4
	throttle_deadzone_reset_timer.one_shot = true
	throttle_deadzone_reset_timer.timeout.connect(_on_throttle_deadzone_reset_timer_timeout)
	
	supercruise_initialization_timer.wait_time = 1
	supercruise_initialization_timer.one_shot = true
	supercruise_initialization_timer.timeout.connect(_on_supercruise_initialization_timer_timeout)
	
	if control_entity is Starship:
		control_entity.alcubierre_drive_inserted.connect(on_alcubierre_drive_inserted)
		control_entity.alcubierre_drive_removed.connect(on_alcubierre_drive_removed)

func _process(delta: float) -> void:
	_starship_controller_process(delta)
	
func on_alcubierre_drive_removed(alcubierre_drive : Module) -> void:
	starship_has_alcubierre_drive = false
	
func on_alcubierre_drive_inserted(alcubierre_drive : Module) -> void:
	starship_has_alcubierre_drive = true
	supercruise_initialization_timer.wait_time = (alcubierre_drive as AlcubierreDrive).module_resource.spool_time


func _starship_controller_process(delta : float) -> void:
	if control_entity is Starship:
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

		if (Input.is_action_just_pressed("player_interact")):
			starship_player_interact_command.execute(control_entity)

		if (Input.is_action_just_pressed("vehicle_exit_seat")):
			if control_entity.relative_linear_velocity.length() < 10 and control_entity.is_in_abyss == false and control_entity.travel_mode != StarshipTravelModes.TravelMode.SUPER_CRUISE:
				vehicle_exit_seat_command.execute(control_entity)

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
			if control_entity.travel_mode == StarshipTravelModes.TravelMode.SUPER_CRUISE:
				control_entity.exit_super_cruise()
			else:
				supercruise_initialization_timer.start()
		
		if (Input.is_action_just_released("starship_initiate_super_cruise")):
			supercruise_initialization_timer.stop()
			
		if (Input.is_action_pressed("starship_shoot_primary_weapons")):
			starship_shoot_primary_command.execute(control_entity)
		
		if (Input.is_action_pressed("starship_shoot_secondary_weapons")):
				starship_shoot_secondary_command.execute(control_entity)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
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
		control_entity.initiate_super_cruise()
