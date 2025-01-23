extends ControlEntity

class_name Creature

@export_category("Movement")
@export
var walk_speed : float = 3

@export
var walk_force : float = 500

@export
var run_multiplier : float = 1.8

@export
var jump_force : float = 450

@export
var grounded_marker : Marker3D

@export_category("Interaction")

@export
var interaction_length : float = 2.5

@export
var pick_up_distance : float = 1

var game_entity_being_picked_up : GameEntity

@export_category("Keep Upright")

@export
var fall_timer : Timer

@export
var upright_force_p : float = 110.0  # Proportional gain

@export
var upright_force_i : float = 0.01  # Integral gain

@export
var upright_force_d : float = 8.0  # Derivative gain

var upright_integral : float = 0.0

var last_tilt_angle : float = 0.0

var last_time : float = 0.0

var upright_direction : Vector3 = Vector3.UP

var input_vector : Vector3

@export
var ground_shape_cast : ShapeCast3D

@export
var stand_up_shape_cast : ShapeCast3D

var is_on_ground : bool

@export_category("Damping")

@export
var ground_walk_damp : float = 10

@export
var fall_damp : float = 0

@export
var zero_g_damp : float = 0

@export
var zero_g_overspeed_damp : float = 10

var raycast_helper : RaycastHelper = RaycastHelper.new()

var is_running : bool = false

var is_falling : bool = false

var orignal_collision_shape : Shape3D

var rotation_y_last_frame : float

func _ready() -> void:
	creature_ready()

func creature_ready() -> void:
	_default_ready()
	fall_timer.timeout.connect(fall_timer_timeout)
	can_freeze = false
	ground_shape_cast.add_exception(self)
	stand_up_shape_cast.add_exception(self)
	orignal_collision_shape = $CollisionShape3D.shape

func fall_timer_timeout() -> void:
	if !is_grounded():
		is_falling = true

func _physics_process(delta : float) -> void:
	creature_physics_process(delta)

func creature_physics_process(delta : float) -> void:
	_default_physics_process(delta)

# Stop local angular velocity in the Y axis
	var local_ang_vel : Vector3 = angular_velocity * basis.inverse()
	if abs(local_ang_vel.y) > 0.1:
		local_ang_vel.y = 0
		angular_velocity = (local_ang_vel * basis)



	is_on_ground = is_grounded()

	# INFO The damping code is a bit confusing and definetely is gonna need an overhaul in the future

	# reduce damping if not in gravity
	if !is_in_gravity():
		is_falling = false
		linear_damp = fall_damp
	else:
		linear_damp = ground_walk_damp

	# reduce damping if falling or not on the ground
	if (is_falling):
		linear_damp = fall_damp
	elif (!is_on_ground):
		linear_damp = 0
	elif is_in_gravity():
		linear_damp = ground_walk_damp

	var multiplier : float = 1

	if is_running == true:
		multiplier = run_multiplier

	# if on ground and walking use walk damp
	if relative_linear_velocity.length() > walk_speed * multiplier or input_vector == Vector3.ZERO:
		if is_on_ground:
			linear_damp = ground_walk_damp
	else:
		linear_damp = fall_damp
		physics_material_override.friction = 0.2

	if input_vector == Vector3.ZERO:
		physics_material_override.friction = 1
	else:
		physics_material_override.friction = 0.2



	var direction : Vector3 = (anchor.twist_pivot.global_transform.basis * input_vector).normalized()

	if is_on_ground and is_in_gravity():
		apply_central_force(direction * walk_force * multiplier)

	keep_upright(delta)

	if (game_entity_being_picked_up != null):
		pick_up(game_entity_being_picked_up, delta)

	# reduce size of collision shape if in zero-g environment
	if !is_in_gravity():
		$CollisionShape3D.shape = SphereShape3D.new()
		($CollisionShape3D.shape as SphereShape3D).radius = 0.4
		$CollisionShape3D.position.y = 0.4
	else:
		$CollisionShape3D.shape = orignal_collision_shape
		$CollisionShape3D.position.y = 0


	is_running = false

func move(input_dir : Vector2) -> void:
	input_vector = Vector3(input_dir.x, 0, input_dir.y)


func look(twist_input : float, pitch_input : float) -> void:
	anchor.look(twist_input, pitch_input)

func run() -> void:
	is_running = true

func jump() -> void:
	if is_in_gravity() and is_on_ground:
		apply_central_impulse(global_transform.basis.y * jump_force)

func is_grounded() -> bool:
	if ground_shape_cast.is_colliding():
		is_falling = false
		return true

	if stand_up_shape_cast.is_colliding():
		is_falling = false
		return false

	if fall_timer.is_stopped():
		fall_timer.start()

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
	game_entity.angular_velocity = Vector3.ZERO

func drop() -> void:
	game_entity_being_picked_up.on_game_entity_drop_request.disconnect(drop)
	game_entity_being_picked_up.is_being_held = false
	game_entity_being_picked_up = null

func keep_upright(delta: float) -> void:
	if !is_in_gravity():
		return

	if is_falling:
		return

	if !is_on_ground and !stand_up_shape_cast.is_colliding():
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
