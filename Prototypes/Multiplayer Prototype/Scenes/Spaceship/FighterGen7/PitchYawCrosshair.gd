extends Sprite3D


var x_offset : float
var y_offset : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset.x = x_offset
	offset.y = y_offset


func _on_user_control_yaw(percent):
	x_offset = percent


func _on_user_control_pitch(percent):
	y_offset = -percent
