extends Node3D

class_name Player

@export
var mouse_sensivity : float = 0.001

var twist_input : float = 0.0
var pitch_input : float = 0.0

@export
var controlling : ControlEntity

@onready
var raycast : RayCast3D = $InteractionRayCast

# Laikan Commands
var laikan_movement_command : LaikanMovementCommand = LaikanMovementCommand.new()
var laikan_jump_command : LaikanJumpCommand = LaikanJumpCommand.new()
var laikan_look_command : LaikanLookCommand = LaikanLookCommand.new()


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and mouse_sensivity > 0):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if (Input.is_action_just_pressed("player_interact")):
		raycast.clear_exceptions()
		
		if controlling:
			raycast.add_exception(controlling)
		
		if raycast.is_colliding():
			var collider : Object = raycast.get_collider()
			
			if collider is ControlEntity:
				
				controlling = collider
				
				print("Controlling entity set to: ", controlling)
			else:
				print("The object is not possessable. :", collider)
	
	if controlling == null:
		return
	
	self.global_position = controlling.anchor.global_position
	self.global_rotation = controlling.anchor.global_rotation
	
	if controlling is Laikan:
		var input_dir : Vector2 = Input.get_vector("player_walk_left", "player_walk_right", "player_walk_forwards", "player_walk_backwards")
		
		laikan_movement_command.execute(controlling, LaikanMovementCommand.Params.new(input_dir))
		
		laikan_look_command.execute(controlling, LaikanLookCommand.Params.new(twist_input, pitch_input))
		
		if (Input.is_action_just_pressed("player_jump")):
			laikan_jump_command.execute(controlling)
			
	pitch_input = 0
	twist_input = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity
