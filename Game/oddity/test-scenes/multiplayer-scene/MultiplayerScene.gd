extends Node3D

@export
var player_scene : PackedScene

@export
var creature_scene : PackedScene

@export
var ship_scnee : PackedScene

func _ready() -> void:
	var index : int = 0
		
	for i : Variant in GameManager.players:
		var currentPlayer : Player = player_scene.instantiate()
		var creature : Creature = creature_scene.instantiate()
		var ship : Starship = ship_scnee.instantiate()
		
		
		currentPlayer.name = str(GameManager.players[i].id)
		currentPlayer.player_name = str(GameManager.players[i].name)
		creature.name = str(GameManager.players[i].id) + " creature"
		
		get_tree().get_first_node_in_group("World").add_child(currentPlayer)
		get_tree().get_first_node_in_group("World").add_child(creature)
		get_tree().get_first_node_in_group("World").add_child(ship)


		print("player spawned")
		
		for spawn : Marker3D in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				creature.global_position = spawn.global_position + Vector3(10, 0, 0)
				ship.global_position = spawn.global_position
				ship.synchroniser.set_multiplayer_authority(str(currentPlayer.name).to_int())
				ship.spawn_pos = spawn.global_position
				ship.spawn_point = spawn
				ship.global_rotation = spawn.global_rotation
				currentPlayer.possess(creature)
				
				
		index += 1
