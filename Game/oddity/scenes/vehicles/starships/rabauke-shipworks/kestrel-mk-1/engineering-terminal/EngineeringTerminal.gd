extends ControlEntity

class_name EngineeringTerminal

@export
var starship : Starship

var player_control_entity : ControlEntity

@export
var screen : EngineeringTerminalScreen

func _ready() -> void:
	super._ready()
	
func exit_terminal() -> void:
	world.player.possess(player_control_entity)

func _on_interactable_interacted(player: Player, control_entity: ControlEntity) -> void:
	player_control_entity = control_entity
	player.possess(self)
