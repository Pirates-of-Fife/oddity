extends Node3D

@export
var is_first_person_crosshair : bool

var x_offset : float
var y_offset : float

@onready
var crosshairSprite = $crosshairUI1stPerson

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
 # Calculate the distance from the center (0,0) to the current position
	var distance = Vector2(x_offset, y_offset).length()

	# Map the distance to a scale value between 30% and 100%
	var scale = lerp(1.0, 0.3, distance / 100)
	
	scale = clamp(scale, 0.3, 1.0);

	crosshairSprite.scale = Vector3(scale, scale, scale)
	
	crosshairSprite.offset.x = x_offset / scale
	crosshairSprite.offset.y = y_offset / scale

func _on_cameras_is_first_person_signal(is_first_person):
	if (is_first_person and not is_first_person_crosshair):
		hide()
	else:
		show()


func _on_player_input_send_rotation_vector(rotation_vector):
	x_offset = rotation_vector.y * 100
	y_offset = rotation_vector.x * -100
