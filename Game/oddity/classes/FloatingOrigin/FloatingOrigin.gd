extends Node3D

class_name FloatingOrigin

# Amount of distance before shifting
@export 
var shift_threshold : float = 2000.0

# Reference to main player
@export
var player : Player = null

func _ready() -> void:
	if player == null:
		player = get_tree().get_nodes_in_group("Player")[0] # There will never be more than one player if using floating origin

func _physics_process(delta: float) -> void:	
	if(player.control_entity.global_transform.origin.length() > shift_threshold && player.control_entity != null):
		shift_origin()

func shift_origin() -> void:
	#=============================================================================================#
	# INFO Workaround due to origin shifting not working if the player is in a frame of reference #
	#=============================================================================================#
	if (player.control_entity.in_frame_of_references.size() > 0):
		return
	
	global_transform.origin -= player.control_entity.global_transform.origin
	player.control_entity.global_position = Vector3.ZERO
