# @class FrameOfReference
# This class handles a localized physics system for bodies within a specific reference frame.
# It tracks and updates the position, velocity, and rotation of objects relative to the reference frame.
# This allows objects to behave according to local physics while the reference frame itself is in motion.

@icon("res://classes/frame of reference/Icons/FrameOfReference.svg")

extends Area3D

class_name FrameOfReference

var bodies_in_reference_frame : Array = Array()
var frame_of_references_in_reference_frame : Array = Array()

var last_position : Vector3 = Vector3.ZERO
var movement_delta : Vector3 = Vector3.ZERO

var last_rotation : Quaternion
var rotation_delta : Quaternion

var velocity : Vector3 = Vector3.ZERO
var last_velocity : Vector3 = Vector3.ZERO
var velocity_delta : Vector3 = Vector3.ZERO

@export
var frame_of_reference_name : String = ""

@export
var size : FrameOfReferenceSize

enum FrameOfReferenceSize 
{
	SMALL,
	MEDIUM,
	LARGE,
	HUGE,
	STATION,
	MOON,
	PLANET,
	STAR
}

func _init() -> void:
	var error_enter : Error = self.connect("body_entered", _on_body_entered)
	var error_exit : Error = self.connect("body_exited", _on_body_exited)

	if (error_enter != OK):
		printerr(str(self) + " failed to connect to body_entered.")
	
	if (error_exit != OK):
		printerr(str(self) + " failed to connect to body_exited.")
		
func _enter_tree() -> void:
	last_position = global_position
	last_velocity = velocity
	last_rotation = global_basis.get_rotation_quaternion().normalized()
	
func _physics_process(delta: float) -> void:
	calculate_movement_deltas(delta)
	move_bodies_in_frame_of_reference()

func calculate_movement_deltas(delta : float) -> void:
	velocity = movement_delta / delta
	velocity_delta = velocity - last_velocity
	last_velocity = velocity
	
	movement_delta = global_position - last_position
	last_position = global_position
	
	rotation_delta = global_basis.get_rotation_quaternion() * last_rotation.inverse()
	last_rotation = global_basis.get_rotation_quaternion()

func move_bodies_in_frame_of_reference() -> void:
	for body : GameEntity in bodies_in_reference_frame:
		move_body(body)

func apply_gravity() -> void:
	pass

func move_body(body : GameEntity) -> void:
	if body.active_frame_of_reference != self:
		return
		
	var origin_vector : Vector3 = vector_origin_body(body)
	
	var new_position_vector : Vector3 = rotation_delta.normalized() * origin_vector
	var new_position : Vector3 = global_position + new_position_vector
	
	var body_movement_vector_delta : Vector3 = new_position - body.global_position 
	
	body.global_position += movement_delta + body_movement_vector_delta
	
	var new_transform : Transform3D = body.global_transform
	new_transform.basis = Basis(rotation_delta) * new_transform.basis
	body.global_transform = new_transform

func vector_origin_body(body : GameEntity) -> Vector3:
	return body.global_position - global_position

func _on_body_entered(body : Node3D) -> void:
	body_entered(body)
	
func _on_body_exited(body : Node3D) -> void:
	body_exited(body)

func body_entered(body : Node3D) -> void:
	if (body is GameEntity):
		bodies_in_reference_frame.append(body)
		body.in_frame_of_references.append(self)
		body.evaluate_active_frame_of_reference()
		
func body_exited(body : Node3D) -> void:
	if (body is GameEntity):
		bodies_in_reference_frame.erase(body)
		body.in_frame_of_references.erase(self)
		body.evaluate_active_frame_of_reference()
