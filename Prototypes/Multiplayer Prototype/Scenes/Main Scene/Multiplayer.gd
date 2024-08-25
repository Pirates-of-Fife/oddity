extends Node3D

class_name MainScene

@export
var player_scene : PackedScene

func _ready():
	var index : int = 0
	
	for i in GameManager.players:
		var currentPlayer = player_scene.instantiate()
		
		currentPlayer.name = str(GameManager.players[i].id)
		
		if (currentPlayer.get_node("MultiplayerSynchronizer").get_multiplayer_authority() == multiplayer.get_unique_id()):
			$SubViewportContainer/SubViewport.add_child(currentPlayer)
		else:
			$SubViewportContainer/SubViewport/World.add_child(currentPlayer)
		
		
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		
		index += 1
