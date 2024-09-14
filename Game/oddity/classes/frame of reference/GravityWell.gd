# @class GravityWell
# This class adds a point-gravity frame of reference.
# Used for celestial objects like planets or stars.

@icon("res://classes/frame of reference/Icons/GravityWell.svg")

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
var gravity_strength : float = 9.8 : 
	set(value):
		gravity = value * 9.8
		

func _ready() -> void:
	if (radius <= 0):
		radius = 1
	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	var sphere_shape : SphereShape3D = SphereShape3D.new()
	sphere_shape.radius = radius
	
	collision_shape.shape = sphere_shape
	add_child(collision_shape)
	
	if (enable_gravity):
		gravity_space_override = SpaceOverride.SPACE_OVERRIDE_REPLACE
		gravity_point = true
		gravity_point_center = Vector3.ZERO
		gravity_point_unit_distance = radius * (1 + gravity_attraction_from_surface_max / 100.0)
	else:
		gravity_space_override = SpaceOverride.SPACE_OVERRIDE_DISABLED
	
func _physics_process(delta: float) -> void:
	calculate_movement_deltas(delta)
	move_bodies_in_frame_of_reference()

func _on_body_entered(body : Node3D) -> void:
	if (body is RigidBody3D):
		bodies_in_reference_frame.append(body)
	
func _on_body_exited(body : Node3D) -> void:
	if (body is RigidBody3D):
		bodies_in_reference_frame.erase(body)
