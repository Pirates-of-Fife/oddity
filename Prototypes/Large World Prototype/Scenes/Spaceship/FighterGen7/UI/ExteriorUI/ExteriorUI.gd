extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_cameras_is_first_person_signal(is_first_person):
	if (is_first_person):
		hide()
	else:
		show()


func _on_fighter_gen_7_output_velocity(velocity : Vector3):
	$Speed.text = str(round(velocity.length())) + " m/s"


func _on_player_input_send_movement_vector(movement_vector):
	$ThrustBar2D.value = abs(movement_vector.z * 100)
