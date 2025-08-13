extends Creature

class_name Humanoid

@export_category("EVA")

@export
var can_eva : bool = true

@export
var eva_speed : float = 5

@export
var eva_force : float = 450

@export
var eva_roll_force : float = 50

var eva_movement_vector : Vector3
var eva_rotation_vector : Vector3


func humanoid_process(delta : float) -> void:
	pass

func _physics_process(delta: float) -> void:
	humanoid_physics_process(delta)

func humanoid_physics_process(delta : float) -> void:
	creature_physics_process(delta)

	if !is_in_gravity() and can_eva:
		if relative_linear_velocity.length() > eva_speed:
			linear_damp = zero_g_overspeed_damp
		else:
			linear_damp = zero_g_damp

		apply_central_force(eva_movement_vector * eva_force * anchor.pitch_pivot.global_transform.basis.inverse())
		apply_torque(eva_rotation_vector * eva_roll_force * anchor.pitch_pivot.global_transform.basis.inverse())

	eva_movement_vector = Vector3.ZERO
	eva_rotation_vector = Vector3.ZERO

func eva_move_backwards() -> void:
	eva_movement_vector.z = 1

func eva_move_down() -> void:
	eva_movement_vector.y = -1

func eva_move_forwards() -> void:
	eva_movement_vector.z = -1

func eva_move_left() -> void:
	eva_movement_vector.x = -1

func eva_move_right() -> void:
	eva_movement_vector.x = 1

func eva_move_up() -> void:
	eva_movement_vector.y = 1

func eva_roll_left() -> void:
	eva_rotation_vector.z = -1

func eva_roll_right() -> void:
	eva_rotation_vector.z = 1
