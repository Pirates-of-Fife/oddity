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
				body.relative_gravity_vector = gravity_vector * body.global_basis.inverse() * gravity_strenth * body.mass
				body.relative_gravity_direction = gravity_vector * body.global_basis.inverse()
				body.gravity_strength = gravity_strenth

			body.apply_central_force(gravity_vector * gravity_strenth * body.mass * body.gravity_scale)
			#print(str(body) + " " + str(gravity_vector * gravity_strenth * body.mass))

func calculate_gravity_vector(body : GameEntity) -> Vector3:
	return (global_position - body.global_position).normalized()

## Calculate gravity strength based on distance from the gravity well center
## Implementation based on Godot Jolt's compute_gravity method
func calculate_gravity_strength(body : GameEntity) -> float:
	# Get the point in the gravity well's local space
	var point : Vector3 = body.global_position
	var to_point : Vector3 = point - global_position
	
	# Calculate distance from center
	var to_point_dist_sq : float = to_point.length_squared()
	
	# Check if we're at the point gravity position (avoid division by zero)
	if to_point_dist_sq == 0.0:
		return gravity_strength
	
	# Calculate gravity distance squared based on point_gravity_distance
	var point_gravity_distance : float = radius * (1 + gravity_attraction_from_surface_max / 100.0)
	var gravity_dist_sq : float = point_gravity_distance * point_gravity_distance
	
	# Apply inverse square law for gravity falloff
	return (gravity_strength * gravity_dist_sq / to_point_dist_sq)

func _on_body_entered(body : Node3D) -> void:
	on_body_entered(body)

func _on_body_exited(body : Node3D) -> void:
	on_body_exited(body)
