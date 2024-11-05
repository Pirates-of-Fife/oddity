extends ControlEntity

class_name Creature

# WARNING: TEMPORARY CODE #

@export_category("Movement")
@export
var walk_force : float = 1000

@export
var run_multiplier : float = 4

@export
var jump_force : float = 400

@export
var grounded_marker : Marker3D

@export_flags_3d_physics
var valid_ground_layers : int

@export_category("Interaction")

@export
var interaction_length : float = 2.5

@export
var pick_up_distance : float = 1

var game_entity_being_picked_up : GameEntity

@export_category("PID Settings")
@export
var upright_force_p : float = 110.0  # Proportional gain

@export
var upright_force_i : float = 0.01  # Integral gain

@export
var upright_force_d : float = 8.0  # Derivative gain

var upright_integral : float = 0.0

var last_tilt_angle : float = 0.0

# Other variables for applying force
var last_time : float = 0.0

var upright_direction : Vector3 = Vector3.UP

var input_vector : Vector3

var raycast_helper : RaycastHelper = RaycastHelper.new()

var is_running : bool = false

func _ready() -> void:
	_default_ready()
	
	can_freeze = false

func _physics_process(delta : float) -> void:
	_default_physics_process(delta)
	
	var multiplier : float = 1
	
	if is_running == true:
		multiplier = run_multiplier
	
	var direction : Vector3 = (anchor.twist_pivot.global_transform.basis * input_vector).normalized()

	apply_central_force(direction * walk_force * multiplier)
	
	keep_upright(delta)
	
	if (game_entity_being_picked_up != null):
		pick_up(game_entity_being_picked_up, delta)
		
	is_running = false

func move(input_dir : Vector2) -> void:
	input_vector = Vector3(input_dir.x, 0, input_dir.y)

func look(twist_input : float, pitch_input : float) -> void:
	anchor.look(twist_input, pitch_input)

func run() -> void:
	is_running = true

func jump() -> void:
	if is_in_gravity() and is_grounded():
		apply_central_impulse(global_transform.basis.y * jump_force)

func is_grounded() -> bool:
	var raycast_result : Dictionary = raycast_helper.cast_downwards_raycast(grounded_marker, 0.15, self, valid_ground_layers)
	
	if raycast_result.size() > 0:
		return true
		
	return false
	
func is_in_gravity() -> bool:
	if active_frame_of_reference == null:
		return false
		
	if active_frame_of_reference is GravityGrid or active_frame_of_reference is GravityWell:
		if active_frame_of_reference.gravity_strength > 0:
			return true
			
	return false
	
func use_interact() -> void:
	var result : Dictionary = raycast_helper.cast_raycast_from_node(anchor.camera_anchor, interaction_length)
	
	if (game_entity_being_picked_up != null):
		drop()
		return
	
	if result.size() > 0:
		var collider : Object = result["collider"]

		if collider is Interactable:
			collider.interact(player, self)
	
		if collider is GameEntity:
			if collider.can_be_picked_up == true:
				game_entity_being_picked_up = collider
				game_entity_being_picked_up.is_being_held = true
				game_entity_being_picked_up.on_interact.emit()
				game_entity_being_picked_up.on_game_entity_drop_request.connect(drop)


func pick_up(game_entity : GameEntity, delta : float) -> void:
	var entity_goal_position : Vector3 = anchor.camera_anchor.global_position + Vector3(0, 0, -pick_up_distance) * anchor.camera_anchor.global_basis.inverse()

	game_entity.global_position = entity_goal_position

func drop() -> void:
	game_entity_being_picked_up.on_game_entity_drop_request.disconnect(drop)
	game_entity_being_picked_up.is_being_held = false
	game_entity_being_picked_up = null
	
func keep_upright(delta: float) -> void:
	if !is_in_gravity():
		return
	
	var current_up: Vector3 = global_transform.basis.y
	
	var tilt_axis: Vector3 = current_up.cross(upright_direction).normalized()
	var tilt_angle: float = acos(clamp(current_up.dot(upright_direction), -1.0, 1.0))

	var proportional: float = tilt_angle * upright_force_p

	upright_integral += tilt_angle
	var integral: float = upright_integral * upright_force_i

	var derivative: float = ((tilt_angle - last_tilt_angle) / delta) * upright_force_d
	last_tilt_angle = tilt_angle

	var corrective_torque: float = proportional + integral + derivative
	
	if tilt_angle > 0.01:
		apply_torque_impulse(tilt_axis * corrective_torque)

	if tilt_angle < 0.01:
		upright_integral = 0.0
