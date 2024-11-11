# @class GravityWell
# This class adds a point-gravity frame of reference.
# Used for celestial objects like planets or stars.

@icon("res://classes/frame-of-reference/icons/GravityWell.svg")

extends FrameOfReference

class_name GravityWell

@export_category("Celestial Body")

@export
var radius : float = 1.0

@export_range(0, 100, 0.5, "suffix:%")
var gravity_attraction_from_surface_start : float = 20

@export_range(0, 100, 0.5, "suffix:%")
var gravity_attraction_from_surface_max : float = 1 :
	set(value):
		gravity_attraction_from_surface_max = value
		
		if (value > gravity_attraction_from_surface_start):
			gravity_attraction_from_surface_start = value

@export_category("Gravity")

@export
var enable_gravity : bool = true :
	set(value):
		enable_gravity = value
		
		if (value):
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_REPLACE
			gravity_point = true
			gravity_point_center = Vector3.ZERO
			gravity_point_unit_distance = radius * (1 + gravity_attraction_from_surface_max / 100.0)
		else:
			gravity_space_override = SpaceOverride.SPACE_OVERRIDE_DISABLED

@export_range(0, 10, 0.1, "suffix:G")
var gravity_strength : float = 1 

func _ready() -> void:
	if (radius <= 0):
		radius = 1
	
	gravity_strength *= 9.8
	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	var sphere_shape : SphereShape3D = SphereShape3D.new()
	sphere_shape.radius = radius * (1 + gravity_attraction_from_surface_start / 100.0)
	
	collision_shape.shape = sphere_shape
	add_child(collision_shape)
	
func _physics_process(delta: float) -> void:
	calculate_movement_deltas(delta)
	move_bodies_in_frame_of_reference()
	apply_gravity()
	
func apply_gravity() -> void:
	for body : GameEntity in bodies_in_reference_frame:
		if body.is_being_held:
			continue
		
		if body.active_frame_of_reference == self:
			var gravity_vector : Vector3 = calculate_gravity_vector(body)
			var gravity_strenth : float = calculate_gravity_strength(body)
						
			if (body is Creature):
				body.upright_direction = -gravity_vector
				
			if (body is Starship):
				body.relative_gravity_vector = gravity_vector * body.global_basis.inverse() * gravity_strenth
				body.relative_gravity_direction = gravity_vector * body.global_basis.inverse()
				body.gravity_strength = gravity_strenth
			
			body.apply_central_force(gravity_vector * gravity_strenth * body.mass)
			#print(str(body) + " " + str(gravity_vector * gravity_strenth * body.mass))

func calculate_gravity_vector(body : GameEntity) -> Vector3:
	return (global_position - body.global_position).normalized()

#*********************************************************************************#
# INFO WARNING not working right now, so just applying full gravity all the time. #
#*********************************************************************************#

func calculate_gravity_strength(body : GameEntity) -> float:
	#var distance_from_center : float = (body.global_position - global_position).length()
	#var distance_from_surface : float = max(0, distance_from_center - radius)

	#var distance_max_gravity_attraction : float = radius * (1 + gravity_attraction_from_surface_max / 100.0) 
	#var distance_min_gravity_attraction : float = radius * (1 + gravity_attraction_from_surface_start / 100.0)

	#if distance_from_surface <= distance_min_gravity_attraction:
	#	return (distance_from_surface / distance_min_gravity_attraction) * gravity_strength
	#else:
	#	return 0.0
	
	return gravity_strength

func _on_body_entered(body : Node3D) -> void:
	body_entered(body)
	
func _on_body_exited(body : Node3D) -> void:
	body_exited(body)
