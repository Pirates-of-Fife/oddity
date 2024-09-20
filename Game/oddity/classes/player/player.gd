extends Node3D

class_name Player

@export
var mouse_sensivity : float = 0.001

var twist_input : float = 0.0
var pitch_input : float = 0.0

@export
var control_entity : ControlEntity

@onready
var raycast : RayCast3D = $InteractionRayCast

# Creature Commands
var creature_movement_command : CreatureMovementCommand = CreatureMovementCommand.new()
var creature_jump_command : CreatureJumpCommand = CreatureJumpCommand.new()
var creature_look_command : CreatureLookCommand = CreatureLookCommand.new()

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
			
	pitch_input = 0
	twist_input = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity
