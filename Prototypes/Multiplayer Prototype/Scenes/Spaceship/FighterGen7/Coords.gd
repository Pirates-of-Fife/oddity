extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(get_parent().get_parent().get_parent().get_parent().get_parent().name) + str(round(get_parent().get_parent().get_parent().position))
