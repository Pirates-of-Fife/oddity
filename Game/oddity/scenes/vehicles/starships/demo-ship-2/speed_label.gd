extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str((get_parent_node_3d().get_parent_node_3d() as Starship).relative_linear_velocity.length())
