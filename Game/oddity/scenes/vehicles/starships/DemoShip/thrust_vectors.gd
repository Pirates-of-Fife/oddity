extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(round(get_parent_node_3d().get_parent_node_3d().actual_thrust_vector)) + " " + str(round(get_parent_node_3d().get_parent_node_3d().actual_rotation_vector))
