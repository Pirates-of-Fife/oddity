extends Node3D

class_name Player

@export_category("Control Settings")

@export
var mouse_sensivity : float = 0.001

@export
var keyboard_throttle_sensitivity : float = 0.8

@export
var keyboard_throttle_deadzone : float = 0.15

var twist_input : float = 0.0
var pitch_input : float = 0.0

@export_category("Control Entity")
@export
var control_entity : ControlEntity

@onready
var raycast : RayCast3D = $InteractionRayCast

# Creature Commands
var creature_movement_command : CreatureMovementCommand = CreatureMovementCommand.new()
var creature_jump_command : CreatureJumpCommand = CreatureJumpCommand.new()
var creature_look_command : CreatureLookCommand = CreatureLookCommand.new()

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

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and mouse_sensivity > 0):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if (Input.is_action_just_pressed("player_interact")):
		raycast.clear_exceptions()
		
		if control_entity:
			raycast.add_exception(control_entity)
		
		if raycast.is_colliding():
			var collider : Object = raycast.get_collider()
			
			if collider is ControlEntity:
				
				control_entity = collider
				
				print("control_entity entity set to: ", control_entity)
			else:
				print("The object is not possessable. :", collider)
	
	if control_entity == null:
		return
	
	self.global_position = control_entity.anchor.global_position
	self.global_rotation = control_entity.anchor.global_rotation
	
	if control_entity is Creature:
		var input_dir : Vector2 = Input.get_vector("player_walk_left", "player_walk_right", "player_walk_forwards", "player_walk_backwards")
		
		creature_movement_command.execute(control_entity, CreatureMovementCommand.Params.new(input_dir))
		
		creature_look_command.execute(control_entity, CreatureLookCommand.Params.new(twist_input, pitch_input))
		
		if (Input.is_action_just_pressed("player_jump")):
			creature_jump_command.execute(control_entity)
	
	if control_entity is Starship:
		var starship_control_entity : Starship = control_entity
		
		var current_throttle_forwards_axis : float = starship_last_throttle_value #control_entity.target_thrust_vector.z
		
		if (Input.is_action_pressed("starship_throttle_forward")):
			current_throttle_forwards_axis -= keyboard_throttle_sensitivity * delta
		
		if (Input.is_action_pressed("starship_throttle_backward")):
			current_throttle_forwards_axis += keyboard_throttle_sensitivity * delta
		
		current_throttle_forwards_axis = clampf(current_throttle_forwards_axis, -1, 1)
		
		starship_last_throttle_value = current_throttle_forwards_axis
		
		if (current_throttle_forwards_axis >= 0):
			starship_thrust_forward_command.execute(starship_control_entity, StarshipThrustForwardCommand.Params.new(current_throttle_forwards_axis))
		else:
			starship_thrust_backward_command.execute(starship_control_entity, StarshipThrustBackwardCommand.Params.new(current_throttle_forwards_axis))
		
		if (Input.is_action_pressed("starship_throttle_left")):
			starship_thrust_left_command.execute(starship_control_entity, StarshipThrustLeftCommand.Params.new(Input.get_action_strength("starship_throttle_left")))

		if (Input.is_action_pressed("starship_throttle_right")):
			starship_thrust_right_command.execute(starship_control_entity, StarshipThrustRightCommand.Params.new(Input.get_action_strength("starship_throttle_right")))

		#if (Input.is_action_just_pressed("sta"))
		
	
	# Reset mouse input
	pitch_input = 0
	twist_input = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity
