extends RigidBody3D

class_name GameEntity

signal on_interact

signal on_game_entity_drop_request

@export_category("Interaction")

@export
var can_be_picked_up : bool = false

@export
var is_being_held : bool = false

var active_frame_of_reference : FrameOfReference
var in_frame_of_references : Array = Array()

var original_collision_layer: int
var original_collision_mask: int

var last_linear_velocity : Vector3
var last_relative_linear_velocity : Vector3

var acceleration : Vector3

var relative_linear_velocity : Vector3
var relative_angular_velocity : Vector3
var relative_acceleration : Vector3

func _default_physics_process(delta : float) -> void:
	calculate_velocities(delta)

func _default_process(delta : float) -> void:
	pass

func _default_ready() -> void:
	pass 

func evaluate_active_frame_of_reference() -> void:
	if in_frame_of_references.size() > 0:
		in_frame_of_references.sort_custom(_sort_frame_of_references)
		active_frame_of_reference = in_frame_of_references[0]
	
func _sort_frame_of_references(a : FrameOfReference, b : FrameOfReference) -> bool:
	return a.size < b.size
	
func freeze_static() -> void:
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask
	
	collision_layer = (1 << 10) | (1 << 29)  # Combine layer 11 and layer 30
	collision_mask = (1 << 10) | (1 << 29)  # This sets the mask to only detect layer 11
	
	freeze_mode = FreezeMode.FREEZE_MODE_STATIC
	freeze = true
	
func unfreeze() -> void:
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	
	freeze = false

func calculate_velocities(delta : float) -> void:
	acceleration = (linear_velocity - last_linear_velocity) / delta

	if active_frame_of_reference == null:
		relative_acceleration = acceleration
		relative_angular_velocity = angular_velocity
		relative_linear_velocity = linear_velocity
		last_linear_velocity = linear_velocity
	else:
		relative_linear_velocity = linear_velocity - active_frame_of_reference.velocity
		relative_angular_velocity = angular_velocity - active_frame_of_reference.angular_velocity		
		relative_acceleration = acceleration - active_frame_of_reference.acceleration
		last_relative_linear_velocity = relative_linear_velocity
