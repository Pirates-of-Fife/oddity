extends Camera3D

var acceleration : Vector3
var speed : float
var defaultPosition : Vector3

@export_category("Settings")

@export
var enable_screen_shake : bool

@export_category("First Person Settings")

@export_range(50, 170, 0.5)
var min_fov_first_person : float

@export_range(50, 170, 0.5)
var max_fov_first_person : float

@export
var maximum_movement_first_person : float

@export
var acceleration_movement_factor_first_person : float

@export
var camera_shake_strength_first_person : float

@export_category("Third Person Settings")

@export_range(50, 170, 0.5)
var min_fov_third_person : float

@export_range(50, 170, 0.5)
var max_fov_third_person : float

@export
var maximum_movement_third_person : float

@export
var acceleration_movement_factor_third_person : float

@export
var camera_shake_strength_third_person : float

var current_min_fov : float
var current_max_fov : float
var current_acceleration_movement_factor : float
var current_max_movement : float
var current_camera_shake_strength : float

@export
var cameraacnhor : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultPosition = position
	
	current_min_fov = min_fov_first_person
	current_max_fov = max_fov_first_person
	current_acceleration_movement_factor = acceleration_movement_factor_first_person
	current_max_movement = maximum_movement_first_person
	current_camera_shake_strength = camera_shake_strength_first_person

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	adjust_fov()
	adjust_camera_position()
	
	global_position = cameraacnhor.global_position
	global_rotation = cameraacnhor.global_rotation
	
	if (enable_screen_shake):
		camera_shake()
	
func adjust_camera_position():
	position = position.lerp(acceleration + defaultPosition, get_process_delta_time() * 2.0)
	
func adjust_fov():
	# Define the minimum and maximum speeds for mapping
	var min_speed = -400.0
	var max_speed = 400.0

	# Ensure that the speed is within the specified range
	var current_speed = clamp(speed, min_speed, max_speed)

	# Calculate the FOV based on speed using linear mapping
	fov = lerp(current_min_fov, current_max_fov, (current_speed - min_speed) / (max_speed - min_speed))

func camera_shake():
	var offset =  Vector2(randf(), randf()) * acceleration.length() / current_camera_shake_strength
	h_offset = offset.x
	v_offset = offset.y

func logarithmicTransform(vector):
	var transformedVector = Vector3()

	# Apply the logarithmic transformation to each component of the vector
	transformedVector.x = clamp(log(1 + abs(vector.x)) * sign(vector.x) * current_acceleration_movement_factor, -current_max_movement, current_max_movement)
	transformedVector.y = clamp(log(1 + abs(vector.y)) * sign(vector.y) * current_acceleration_movement_factor, -current_max_movement, current_max_movement)
	transformedVector.z = clamp(log(1 + abs(vector.z)) * sign(vector.z) * current_acceleration_movement_factor, -current_max_movement, current_max_movement)

	return -transformedVector

func _on_cameras_set_default_position(defaultPosition):
	self.defaultPosition = defaultPosition

func _on_cameras_is_first_person_signal(is_first_person):
	if (is_first_person):
		current_min_fov = min_fov_first_person
		current_max_fov = max_fov_first_person
		current_acceleration_movement_factor = acceleration_movement_factor_first_person
		current_max_movement = maximum_movement_first_person
		current_camera_shake_strength = camera_shake_strength_first_person
	else:
		current_min_fov = min_fov_third_person
		current_max_fov = max_fov_third_person
		current_acceleration_movement_factor = acceleration_movement_factor_third_person
		current_max_movement = maximum_movement_third_person
		current_camera_shake_strength = camera_shake_strength_third_person


func _on_fighter_gen_7_output_acceleration(acceleration):
	self.acceleration = logarithmicTransform(acceleration)


func _on_fighter_gen_7_output_velocity(velocity):
	self.speed = velocity.length()
