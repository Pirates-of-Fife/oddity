extends Starship

class_name DemoShip

func _process(delta: float) -> void:
	move_ball()
	
func move_ball() -> void:
	$PlayerCam/SpaceBall.position.x = -target_rotational_thrust_vector.y
	$PlayerCam/SpaceBall.position.y = -target_rotational_thrust_vector.x
	
