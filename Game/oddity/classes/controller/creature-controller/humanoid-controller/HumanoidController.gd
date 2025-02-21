extends CreatureController

class_name HumanoidController

var humanoid_eva_move_backwards_command : HumanoidEvaMoveBackwardsCommand = HumanoidEvaMoveBackwardsCommand.new()
var humanoid_eva_move_down_command : HumanoidEvaMoveDownCommand = HumanoidEvaMoveDownCommand.new()
var humanoid_eva_move_forwards_command : HumanoidEvaMoveForwardsCommand = HumanoidEvaMoveForwardsCommand.new()
var humanoid_eva_move_left_command : HumanoidEvaMoveLeftCommand = HumanoidEvaMoveLeftCommand.new()
var humanoid_eva_movement_command : HumanoidEvaMovementCommand = HumanoidEvaMovementCommand.new()
var humanoid_eva_move_right_command : HumanoidEvaMoveRightCommand = HumanoidEvaMoveRightCommand.new()
var humanoid_eva_move_up_command : HumanoidEvaMoveUpCommand = HumanoidEvaMoveUpCommand.new()
var humanoid_eva_roll_left_command : HumanoidEvaRollLeftCommand = HumanoidEvaRollLeftCommand.new()
var humanoid_eva_roll_right_command : HumanoidEvaRollRightCommand = HumanoidEvaRollRightCommand.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_humanoid_process(delta)


func _humanoid_process(delta : float) -> void:
	_creature_process(delta)

	if control_entity is Humanoid:
		if Input.is_action_pressed("humanoid_eva_forwards"):
			humanoid_eva_move_forwards_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_backwards"):
			humanoid_eva_move_backwards_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_left"):
			humanoid_eva_move_left_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_right"):
			humanoid_eva_move_right_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_up"):
			humanoid_eva_move_up_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_down"):
			humanoid_eva_move_down_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_roll_left"):
			humanoid_eva_roll_left_command.execute(control_entity)

		if Input.is_action_pressed("humanoid_eva_roll_right"):
			humanoid_eva_roll_right_command.execute(control_entity)
