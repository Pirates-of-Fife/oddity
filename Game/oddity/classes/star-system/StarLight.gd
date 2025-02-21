extends DirectionalLight3D

class_name StarLight

@onready
var player : Player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().create_timer(0.5).timeout
		
	look_at(player.global_position, Vector3(0,0,1))
