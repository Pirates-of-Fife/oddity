# @class GravityGrid
# This class adds directional gravity to a FrameOfReference.
# For use in moving and rotation vehicles or structures

@icon("res://classes/frame of reference/Icons/GravityGrid.svg")

extends FrameOfReference

class_name GravityGrid

@export_category("Gravity")

@export
var enable_gravity : bool = true

@export_range(0, 3, 0.1, "suffix:G")
var gravity_strength : float = 1

func _physics_process(delta: float) -> void:
	calculate_movement_deltas(delta)
	move_bodies_in_frame_of_reference()
	set_local_gravity_direction()
	apply_gravity()

func apply_gravity() -> void:
	for body : GameEntity in bodies_in_reference_frame:
		if body.active_frame_of_reference == self:
			if (body is Creature):
				body.upright_direction = -gravity_direction
				
			if (body is Starship):
				body.relative_gravity_vector = gravity_direction * body.global_basis.inverse() * gravity
				body.relative_gravity_direction = gravity_direction * body.global_basis.inverse()
				body.gravity_strength = gravity
			
			body.apply_central_force(gravity_direction * 9.8 * gravity_strength * body.mass)

func set_local_gravity_direction() -> void:
	gravity_direction = -global_transform.basis.y

func _on_body_entered(body : Node3D) -> void:
	body_entered(body)
	
func _on_body_exited(body : Node3D) -> void:
	body_exited(body)
