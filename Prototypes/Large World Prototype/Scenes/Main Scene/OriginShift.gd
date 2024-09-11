extends Node3D



# Amount of distance before shifting
@export 
var threshold : float = 2000.0

# Reference to main player
@export
var player : Node3D = null

@export
var planet : Node3D

var player_moved : bool = false

func _process(delta):
	#print(player.rb.global_transform.origin)
	pass
# Function to contain origin shift logic
func shift_origin() -> void:
	# Shift everything by the offset of the player's position
	global_transform.origin -= player.rb.global_transform.origin
	player.rb.global_position = Vector3.ZERO
	#print("World shifted to " + str(global_transform.origin))

func _physics_process(delta: float) -> void:
	# Set the player to check to be the current player

		#print((planet.global_position - player.rb.global_position).length())
	
	if ((planet.global_position - player.rb.global_position).length() < 40000):
		if (!player_moved):
			player.reparent(planet, true)
			#get_parent_node_3d().move_child(player, planet.get_index(true))
			print("MOVE" + str(planet.get_index(true)))
			player_moved = true
	else:
		if (player_moved):
			player.reparent(get_parent_node_3d(), true)
			#get_parent_node_3d().move_child(player, 0)
			print("BACK")
			player_moved = false
			

	# Check distance of world from player and shift if greater than threshold
	if(player.rb.global_transform.origin.length() > threshold && player != null):
		shift_origin()
