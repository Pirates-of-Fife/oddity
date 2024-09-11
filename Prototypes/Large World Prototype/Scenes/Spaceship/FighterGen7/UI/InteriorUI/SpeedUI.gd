extends Label3D

func _on_fighter_gen_7_output_velocity(velocity : Vector3):
	text = str(round(velocity.length())) + "m/s"
