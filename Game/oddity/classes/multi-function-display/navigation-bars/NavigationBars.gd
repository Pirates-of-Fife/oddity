extends Node3D

class_name NavigationBars

@export
var ship : Starship

func calculate_angle() -> float:
	var gravity_vector : Vector3  = -ship.relative_gravity_direction
	var ship_forwards_vector : Vector3 = Vector3(0, 0, 1)# * ship.global_basis.inverse()
	
	var ange : float = ship.global_position.angle_to(ship.active_frame_of_reference.global_position)
	var pitch : float = ship.global_basis.z.angle_to(ship.active_frame_of_reference.global_position - ship.global_position)
	
	
	var roll : float = ship.global_basis.x.angle_to(ship.global_position - ship.active_frame_of_reference.global_position) - PI/2
		
	return roll
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ship.active_frame_of_reference == null:
		return
		
	if !(ship.active_frame_of_reference is GravityWell):
		return
	
	print(rad_to_deg(calculate_angle()))
	
	$Sprite3D.rotation.z = calculate_angle()
