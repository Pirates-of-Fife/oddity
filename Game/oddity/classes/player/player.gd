extends Node3D

class_name Player

@export_category("Control Settings")

@export
var mouse_sensitivity : float = 0.001

@export
var mouse_joystick_deadzone : float = 0.04

@export
var ship_mouse_controls_sensitivity : float = 0.01

@export
var keyboard_throttle_sensitivity : float = 0.8

@export
var keyboard_throttle_deadzone : float = 0.05

var twist_input : float = 0.0
var pitch_input : float = 0.0

var mouse_yaw : float = 0.0
var mouse_pitch : float = 0.0

@export_category("Interaction")

@export
var interaction_length : float = 2.5

@export_category("Control Entity")
@export
var control_entity : ControlEntity

# Creature Commands


# Starship Commands
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

var starship_last_throttle_value : float = 0
var current_throttle_forwards_axis : float = 0

@onready
var throttle_deadzone_reset_timer : Timer = $ThrottleDeadzoneResetTimer

func _process(delta: float) -> void:	
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and mouse_sensitivity > 0):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if (Input.is_action_just_pressed("player_interact")):
		var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		
		var origin : Vector3 = global_position
		var end : Vector3 = global_position + Vector3(0, 0, -interaction_length) * global_basis.inverse()
		
		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end, 536870912)
		
		var result : Dictionary = space_state.intersect_ray(query)
				
		if result.size() > 0:
			var collider : Object = result["collider"]

			if collider is Interactable:
				collider.interact(self, control_entity)
				
	if control_entity == null:
		return
	
	self.global_position = control_entity.anchor.global_position
	self.global_rotation = control_entity.anchor.global_rotation
	
	
	
	if control_entity is Starship:
		var starship_control_entity : Starship = control_entity
		
		current_throttle_forwards_axis = starship_last_throttle_value #control_entity.target_thrust_vector.z
		
		if (Input.is_action_pressed("starship_throttle_forward")):
			current_throttle_forwards_axis -= keyboard_throttle_sensitivity * delta
		
		if (Input.is_action_pressed("starship_throttle_backward")):
			current_throttle_forwards_axis += keyboard_throttle_sensitivity * delta
		
		current_throttle_forwards_axis = clampf(current_throttle_forwards_axis, -1, 1)
		
		starship_last_throttle_value = current_throttle_forwards_axis
				
		if (current_throttle_forwards_axis <= 0):
			starship_thrust_forward_command.execute(starship_control_entity, StarshipThrustForwardCommand.Params.new(-current_throttle_forwards_axis))
		else:
			starship_thrust_backward_command.execute(starship_control_entity, StarshipThrustBackwardCommand.Params.new(current_throttle_forwards_axis))
		
		if (abs(current_throttle_forwards_axis) < keyboard_throttle_deadzone and current_throttle_forwards_axis != 0):
			if (throttle_deadzone_reset_timer.is_stopped()):
				throttle_deadzone_reset_timer.start()
		
		if (Input.is_action_pressed("starship_throttle_left")):
			starship_thrust_left_command.execute(starship_control_entity, StarshipThrustLeftCommand.Params.new(Input.get_action_strength("starship_throttle_left")))

		if (Input.is_action_pressed("starship_throttle_right")):
			starship_thrust_right_command.execute(starship_control_entity, StarshipThrustRightCommand.Params.new(Input.get_action_strength("starship_throttle_right")))

		if (Input.is_action_pressed("starship_throttle_up")):
			starship_thrust_up_command.execute(starship_control_entity, StarshipThrustUpCommand.Params.new(Input.get_action_strength("starship_throttle_up")))
		
		if (Input.is_action_pressed("starship_throttle_down")):
			starship_thrust_down_command.execute(starship_control_entity, StarshipThrustDownCommand.Params.new(Input.get_action_strength("starship_throttle_down")))
			
		if (Input.is_action_pressed("starship_rotate_roll_left")):
			starship_roll_left_command.execute(starship_control_entity, StarshipRollLeftCommand.Params.new(Input.get_action_strength("starship_rotate_roll_left")))

		if (Input.is_action_pressed("starship_rotate_roll_right")):
			starship_roll_right_command.execute(starship_control_entity, StarshipRollRightCommand.Params.new(Input.get_action_strength("starship_rotate_roll_right")))

		# Starship Mouse Pitch
		
		var deadzoned_yaw : float = mouse_yaw
		var deazoned_pitch : float = mouse_pitch
		
		if abs(mouse_yaw) < mouse_joystick_deadzone:
			deadzoned_yaw = 0

		if abs(mouse_pitch) < mouse_joystick_deadzone:
			deazoned_pitch = 0
				
		if (mouse_pitch > 0):
			starship_pitch_up_command.execute(starship_control_entity, StarshipPitchUpCommand.Params.new(abs(deazoned_pitch)))
		else:
			starship_pitch_down_command.execute(starship_control_entity, StarshipPitchDownCommand.Params.new(abs(deazoned_pitch)))
		
		# Starship Mouse Yaw
	
		if (mouse_yaw > 0):
			starship_yaw_left_command.execute(starship_control_entity, StarshipYawLeftCommand.Params.new(abs(deadzoned_yaw)))
		else:
			starship_yaw_right_command.execute(starship_control_entity, StarshipYawRightCommand.Params.new(abs(deadzoned_yaw)))
	
	
	# Reset mouse input
	pitch_input = 0
	twist_input = 0

func possess(control_entity : ControlEntity) -> void:
	self.control_entity = control_entity
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
			
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
