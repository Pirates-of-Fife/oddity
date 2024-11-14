extends Starship

class_name DemoShip

@export
var velocity_mfd : VelocityMFD3D


func _process(delta: float) -> void:
	move_ball()
	
	velocity_mfd.forwards_velocity = local_linear_velocity.z
	velocity_mfd.lateral_velocity_right = abs(minf(local_linear_velocity.x, 0))
	velocity_mfd.lateral_velocity_left = maxf(local_linear_velocity.x, 0)
	velocity_mfd.vertical_velocity_up = maxf(local_linear_velocity.y, 0)
	velocity_mfd.vertical_velocity_down = abs(minf(local_linear_velocity.y, 0))
	velocity_mfd.max_velocity = ship_info.max_linear_velocity
	velocity_mfd.current_max_velocity = current_max_velocity
	velocity_mfd.throttle = target_thrust_vector.z
	velocity_mfd.velocity = local_linear_velocity.length()
	
func move_ball() -> void:
	$Anchor/SpaceBall.position.x = -target_rotational_thrust_vector.y
	$Anchor/SpaceBall.position.y = -target_rotational_thrust_vector.x
	
