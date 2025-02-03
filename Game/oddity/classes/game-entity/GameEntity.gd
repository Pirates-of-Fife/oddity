extends RigidBody3D

class_name GameEntity

signal on_interact

signal on_game_entity_drop_request

signal on_damage_taken(damage : float)

var is_mass_locked : bool :
	get:
		for i : FrameOfReference in in_frame_of_references:
			if i.mass_lock:
				return true
		return false


@export_category("Value")

@export
var value : int

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

var freeze_velocity_limit : float = 0.1
var freeze_timer : Timer = Timer.new()
var freeze_timer_duration : float = 1
var timer_started : bool = false

var can_freeze : bool = true

@export_category("Debug")
@export
var debug : bool

func _physics_process(delta: float) -> void:
	_default_physics_process(delta)

func _process(delta: float) -> void:
	_default_process(delta)

func _ready() -> void:
	_default_ready()

# WARNING: temporary, damage will depend on penetration and armour values
func take_damage(damage : float) -> void:
	on_damage_taken.emit(damage)

func _default_physics_process(delta : float) -> void:
	calculate_velocities(delta)

	if active_frame_of_reference != null:
		if freeze == false and can_freeze == true and active_frame_of_reference.physics_parent != null:
			if relative_linear_velocity.length() < freeze_velocity_limit:
				if freeze_timer.is_node_ready():
					if freeze_timer.is_stopped():
						freeze_timer.start()

func debug_log(msg : Variant) -> void:
	if debug:
		print(str(self) + str(" Debug: ") + str(msg))

func _default_process(delta : float) -> void:
	pass

func _default_ready() -> void:
	add_child(freeze_timer)

	freeze_timer.wait_time = freeze_timer_duration
	freeze_timer.one_shot = true
	freeze_timer.timeout.connect(freeze_timer_timeout)

	on_interact.connect(on_interact_self)

func on_interact_self() -> void:
	unfreeze()
	unfreeze_in_frame_of_reference()


func unfreeze_in_frame_of_reference() -> void:
	if get_parent_node_3d() is not FrameOfReference:
		return

	for body : Node in get_parent_node_3d().get_children():
		if body == self:
			continue

		if body is GameEntity:
			if body.freeze == true:
				if body.can_be_picked_up == true:
					if body is CargoContainer:
						if (body as CargoContainer).snapped_to == null:
							body.unfreeze()
					else:
						body.unfreeze()



func freeze_timer_timeout() -> void:
	if active_frame_of_reference != null:
		if freeze == false and can_freeze == true and active_frame_of_reference.physics_parent != null and !is_being_held:
			if relative_linear_velocity.length() < freeze_velocity_limit:
				freeze_in_reference_frame()


func evaluate_active_frame_of_reference() -> void:
	if in_frame_of_references.size() > 0:
		in_frame_of_references.sort_custom(_sort_frame_of_references)
		active_frame_of_reference = in_frame_of_references[0]

	if in_frame_of_references.size() == 0:
		active_frame_of_reference = null

func _sort_frame_of_references(a : FrameOfReference, b : FrameOfReference) -> bool:
	return a.size < b.size

func freeze_static() -> void:
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask

	collision_layer = (1 << 10) | (1 << 29)  # Combine layer 11 and layer 30
	collision_mask = (1 << 10) | (1 << 29)  # This sets the mask to only detect layer 11

	freeze_mode = FreezeMode.FREEZE_MODE_STATIC
	freeze = true

func freeze_in_reference_frame() -> void:
	freeze_static()
	reparent.call_deferred(active_frame_of_reference)

func unfreeze() -> void:
	if freeze == false:
		return

	if (get_parent_node_3d() != get_tree().get_first_node_in_group("StarSystem")):
		reparent.call_deferred(get_tree().get_first_node_in_group("StarSystem"))

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
		relative_linear_velocity = linear_velocity - active_frame_of_reference.relative_velocity
		relative_angular_velocity = angular_velocity - active_frame_of_reference.angular_velocity
		relative_acceleration = acceleration - active_frame_of_reference.acceleration
		last_relative_linear_velocity = relative_linear_velocity

func load_nodes(node_paths: Array) -> Array:
	var nodes : Array = []
	for node_path : NodePath in node_paths:
		var node : Node = get_node(node_path)
		if node != null:
			nodes.append(node)
	return nodes
