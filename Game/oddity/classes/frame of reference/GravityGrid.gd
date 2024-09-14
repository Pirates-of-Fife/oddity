# @class GravityGrid
# This class adds directional gravity to a FrameOfReference.
# For use in moving and rotation vehicles or structures

@icon("res://classes/frame of reference/Icons/GravityGrid.svg")

extends FrameOfReference

class_name GravityGrid

@export_category("Gravity")

@export
var enable_gravity : bool = true :
	set(value):
		enable_gravity = value
		
		if (value):
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_REPLACE
		else:
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_DISABLED

@export_range(0, 3, 0.1, "suffix:G")
var gravity_strength : float = 9.8 : 
	set(value):
		gravity = value * 9.8

func _physics_process(delta: float) -> void:
	calculate_movement_deltas(delta)
	move_bodies_in_frame_of_reference()
	set_local_gravity_direction()
	
func set_local_gravity_direction() -> void:
	gravity_direction = -global_transform.basis.y

func _on_body_entered(body : Node3D) -> void:
	if (body is RigidBody3D):
		bodies_in_reference_frame.append(body)
	
func _on_body_exited(body : Node3D) -> void:
	if (body is RigidBody3D):
		bodies_in_reference_frame.erase(body)
