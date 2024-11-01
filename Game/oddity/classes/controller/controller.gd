extends Node

class_name Controller

@export_category("Control Entity")
@export
var control_entity : ControlEntity

var is_multiplayer_authority : bool = false

#==========================================================================================================================================#
# the _default methods contain the standard controls. A child class of a control entity may choose to add new controls to the default set. #
#==========================================================================================================================================#
func _default_process(delta : float) -> void:
	pass

func _default_ready() -> void:
	pass
	
func check_multiplayer_authority(synchroniser : MultiplayerSynchronizer, player : Player) -> void:
	if synchroniser == null:
		return
	
	print("Player " + str(player.player_name) + " " + str(synchroniser.get_multiplayer_authority()) + " " + str(multiplayer.get_unique_id()))
	
	if (synchroniser.get_multiplayer_authority() != multiplayer.get_unique_id()):
		is_multiplayer_authority = false
		
		print("false")
		
		return
	
	is_multiplayer_authority = true

	print("true")
	
