extends Controller

class_name CreatureController

var creature_movement_command : CreatureMovementCommand = CreatureMovementCommand.new()
var creature_jump_command : CreatureJumpCommand = CreatureJumpCommand.new()
var creature_look_command : CreatureLookCommand = CreatureLookCommand.new()
var creature_interact_command : CreatureInteractCommand = CreatureInteractCommand.new()
var creature_run_command : CreatureRunCommand = CreatureRunCommand.new()

@export_category("Control Settings")
@export
var mouse_sensitivity : float = 0.001

var twist_input : float = 0.0
var pitch_input : float = 0.0

func _process(delta: float) -> void:
	_creature_process(delta)

func _creature_process(delta : float) -> void:
	_controller_process(delta)

	if control_entity is Creature:
		var input_dir : Vector2 = Input.get_vector("player_walk_left", "player_walk_right", "player_walk_forwards", "player_walk_backwards")

		creature_movement_command.execute(control_entity, CreatureMovementCommand.Params.new(input_dir))

		creature_look_command.execute(control_entity, CreatureLookCommand.Params.new(twist_input, pitch_input))

		if (Input.is_action_just_pressed("player_jump")):
			creature_jump_command.execute(control_entity)

		if (Input.is_action_just_pressed("player_interact")):
			creature_interact_command.execute(control_entity)

		if (Input.is_action_pressed("player_run")):
			creature_run_command.execute(control_entity)

	pitch_input = 0
	twist_input = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
