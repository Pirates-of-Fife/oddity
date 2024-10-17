extends RigidBody3D

class_name GameEntity

@export_category("Interaction")

@export
var can_be_picked_up : bool = false

@export
var is_being_held : bool = false

var active_frame_of_reference : FrameOfReference
var in_frame_of_references : Array = Array()

func evaluate_active_frame_of_reference() -> void:
	if in_frame_of_references.size() > 0:
		in_frame_of_references.sort_custom(_sort_frame_of_references)
		active_frame_of_reference = in_frame_of_references[0]
	
func _sort_frame_of_references(a : FrameOfReference, b : FrameOfReference) -> bool:
	return a.size < b.size
	
func freeze_static() -> void:
	freeze_mode = FreezeMode.FREEZE_MODE_STATIC
	freeze = true
	
func unfreeze() -> void:
	freeze = false
