extends Node3D



# Amount of distance before shifting
@export 
var threshold : float = 2000.0

# Reference to main player
var player : Node3D

func _ready():
	player = get_parent().get_child(1)

func _process(delta):
	player = get_parent().get_child(1)
	print(player)
	
	if (player == null):
		return
	#print(player.rb.global_transform.origin)

# Function to contain origin shift logic
func shift_origin() -> void:
	# Shift everything by the offset of the player's position
	global_transform.origin -= player.rb.global_transform.origin
	player.rb.global_position = Vector3.ZERO
	print("World shifted to " + str(global_transform.origin))

func _physics_process(delta: float) -> void:
	if (player == null):
		return
	# Set the player to check to be the current player

	# Check distance of world from player and shift if greater than threshold
	if(player.rb.global_transform.origin.length() > threshold && player != null):
		shift_origin()
