extends Starship

class_name RABS_KestrelMk1

@export
var velocity_mfd : VelocityMFD3D

@export
var crosshair : Crosshair3d

func _process(delta: float) -> void:
	crosshair.yaw = -target_rotational_thrust_vector.y
	crosshair.pitch = -target_rotational_thrust_vector.x

	velocity_mfd.forwards_velocity = local_linear_velocity.z
	velocity_mfd.lateral_velocity_right = abs(minf(local_linear_velocity.x, 0))
	velocity_mfd.lateral_velocity_left = maxf(local_linear_velocity.x, 0)
	velocity_mfd.vertical_velocity_up = maxf(local_linear_velocity.y, 0)
	velocity_mfd.vertical_velocity_down = abs(minf(local_linear_velocity.y, 0))
	velocity_mfd.max_velocity = ship_info.max_linear_velocity
	velocity_mfd.current_max_velocity = current_max_velocity
	velocity_mfd.throttle = target_thrust_vector.z
	velocity_mfd.velocity = local_linear_velocity.length()	


func toggle_landing_gear() -> void:
	if $Exterior/LandingGear/RabsKestrelMk1LandingGear.state != 0 and $Exterior/LandingGear/RabsKestrelMk1LandingGear.state != 1:
		print($Exterior/LandingGear/RabsKestrelMk1LandingGear.state)
		print("wrong")
		return
	
	$Exterior/LandingGear/RabsKestrelMk1LandingGear.toggle_open_state()
	$Exterior/LandingGear/RabsKestrelMk1LandingGear2.toggle_open_state()
	$Exterior/LandingGear/RabsKestrelMk1LandingGear3.toggle_open_state()
	
	$LandingCollision.disabled = !$LandingCollision.disabled
	$LandingCollision2.disabled = !$LandingCollision2.disabled
	$LandingCollision3.disabled = !$LandingCollision3.disabled
	
	if $Interior/Bridge/LandingGearLabel.visible:
		$Interior/Bridge/LandingGearLabel.hide()
	else:
		$Interior/Bridge/LandingGearLabel.show()
