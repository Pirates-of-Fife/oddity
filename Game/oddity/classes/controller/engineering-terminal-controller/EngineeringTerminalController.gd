extends Controller

class_name EngineeringTerminalController

var engineering_terminal_exit_command : EngineeringTerminalExitCommand = EngineeringTerminalExitCommand.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	if control_entity is EngineeringTerminal:
		control_entity.screen.focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if control_entity is EngineeringTerminal:
		if Input.is_action_just_pressed("vehicle_exit_seat"):
			engineering_terminal_exit_command.execute(control_entity)
		

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey:
		print(event.as_text_key_label())
		if control_entity is EngineeringTerminal:
			control_entity.screen.type(event.as_text_key_label())
		control_entity.screen.focus()
