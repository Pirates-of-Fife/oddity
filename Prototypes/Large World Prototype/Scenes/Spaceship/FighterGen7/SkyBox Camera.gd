extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



@export
var camera : Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = camera.global_position
	global_rotation = camera.global_rotation
	fov = camera.fov
