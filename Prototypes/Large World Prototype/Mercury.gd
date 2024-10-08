@icon("res://planet.svg")
class_name Planet
extends MeshInstance3D

@export
var player : Node3D

@export
var render_distance : float = 210000.0

@export
var debug : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#player = get_parent_node_3d().get_parent_node_3d().get_parent_node_3d().get_child(3);
	#print(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	var distance = (global_position - player.global_position).length()
	
	#if (debug):
		#print(distance)
	
	if distance > render_distance:
		set_layer_mask_value(20, true)
		set_layer_mask_value(1, false)
	else:
		set_layer_mask_value(20, false)
		set_layer_mask_value(1, true)
		

func _physics_process(delta):
	global_position += Vector3(0, 0, 0.0001)
	rotate(Vector3(1, 0, 0), 0.0002)	
