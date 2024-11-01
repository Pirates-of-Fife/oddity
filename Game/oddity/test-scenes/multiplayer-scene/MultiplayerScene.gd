extends Node3D

@export
var player_scene : PackedScene

@export
var creature_scene : PackedScene

func _ready() -> void:
	var index : int = 0
		
	for i : Variant in GameManager.players:
		var currentPlayer : Player = player_scene.instantiate()
		var creature : Creature = creature_scene.instantiate()
		
		currentPlayer.name = str(GameManager.players[i].id)
		currentPlayer.player_name = str(GameManager.players[i].name)
		creature.name = str(GameManager.players[i].id) + " creature"
		
		get_tree().get_first_node_in_group("World").add_child(currentPlayer)
		get_tree().get_first_node_in_group("World").add_child(creature)

		
		for spawn : Marker3D in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				creature.global_position = spawn.global_position
				currentPlayer.possess(creature)
				
				
		index += 1
