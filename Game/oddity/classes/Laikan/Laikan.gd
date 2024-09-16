extends ControlEntity

class_name Laikan

# WARNING: TEMPORARY CODE #



@export_category("Speed")
@export
var walk_force : float = 1000

@export
var run_multiplier : float = 4

@onready
var twist_pivot : Node3D = $Head/TwistPivot

@onready
var pitch_pivot : Node3D = $Head/TwistPivot/PitchPivot

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
# Commands

var input_vector : Vector3

func _physics_process(delta : float) -> void:
	var multiplier : float = 1
	
	#if Input.is_action_just_pressed("player_jump"):
	
	#if (Input.is_action_pressed("player_run")):
	#	multiplier = run_multiplier
	
	var direction : Vector3 = (twist_pivot.global_transform.basis * input_vector).normalized()

	apply_central_force(direction * walk_force * multiplier)
	
	keep_upright(delta)

func move(input_dir : Vector2) -> void:
	input_vector = Vector3(input_dir.x, 0, input_dir.y)

func look(twist_input : float, pitch_input : float) -> void:
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))

func jump() -> void:
	apply_central_impulse(global_transform.basis.y * 300)

func keep_upright(delta: float) -> void:
	var current_up: Vector3 = global_transform.basis.y
	
	var tilt_axis: Vector3 = current_up.cross(upright_direction).normalized()
	var tilt_angle: float = acos(clamp(current_up.dot(upright_direction), -1.0, 1.0))

	var proportional: float = tilt_angle * upright_force_p

	upright_integral += tilt_angle
	var integral: float = upright_integral * upright_force_i

	var derivative: float = ((tilt_angle - last_tilt_angle) / delta) * upright_force_d
	last_tilt_angle = tilt_angle

	var corrective_torque: float = proportional + integral + derivative

	if tilt_angle > 0.01:  # Avoid tiny corrections
		apply_torque_impulse(tilt_axis * corrective_torque)

	if tilt_angle < 0.01:
		upright_integral = 0.0
