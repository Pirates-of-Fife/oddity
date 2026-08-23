extends Node3D

class_name NavigationBars

@export
var ship : Starship

func calculate_angle() -> float:
	var gravity_vector : Vector3  = ship.to_local(-ship.relative_gravity_direction)
	var ship_up_vector : Vector3 = Vector3(0, 1, 0) * ship.global_basis.inverse()
	
	var facing_down : bool = rad_to_deg(ship_up_vector.angle_to(ship.global_position - ship.active_frame_of_reference.global_position)) >= 90
	
	print(rad_to_deg(ship_up_vector.angle_to(ship.global_position - ship.active_frame_of_reference.global_position)))
		
	if facing_down:
		return ship.global_basis.x.angle_to(ship.active_frame_of_reference.global_position - ship.global_position) - PI / 2
	
	return ship.global_basis.x.angle_to(ship.global_position - ship.active_frame_of_reference.global_position) - PI / 2
	

func calculate_pitch() -> float:
	return ship.global_basis.z.angle_to(ship.global_position - ship.active_frame_of_reference.global_position) - PI / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ship.current_state != ship.State.POWER_ON:
		hide()
		return

	if ship.active_frame_of_reference == null:
		hide()
		return
		
	if !(ship.active_frame_of_reference is GravityWell):
		hide()
		return
		
	show()
	
	$Sprite3D.rotation.z = calculate_angle()
	$Sprite3D2.position.y = normalize(calculate_pitch(), -0.1, 0.1, -PI/2, PI/2)
	$Sprite3D2/Label3D.text = str(roundf(-rad_to_deg(calculate_pitch())))
	

func normalize(x : float, a : float, b : float, min_x : float, max_x : float) -> float:
	return (b - a) * ((x - min_x) / (max_x - min_x)) + a
