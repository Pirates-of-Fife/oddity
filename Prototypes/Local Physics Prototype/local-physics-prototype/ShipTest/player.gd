extends RigidBody3D

class_name Player

@export_category("Mouse Settings")
@export
var mouse_sensivity : float = 0.001

var twist_input : float = 0.0
var pitch_input : float = 0.0

@export_category("Speed")
@export
var walk_force : float = 6

@export_category("Camera Pivots")

@export
var twist_pivot : Node3D

@export
var pitch_pivot : Node3D

var in_control : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Replace with function body.

func _physics_process(delta):
	if (Input.is_action_just_released("switch")):
		if (in_control == false):
			in_control = true
			print(in_control)
		else:
			in_control = false 
			
	if (!in_control):
		return
	
	if (Input.is_anything_pressed() and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and mouse_sensivity > 0):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Handle jump.
	if Input.is_action_just_pressed("move_up"):
		apply_central_impulse(global_transform.basis.y * 2)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var direction = (transform.basis * twist_pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	apply_central_force(direction * walk_force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!in_control):
		return
	
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	#apply_torque(Vector3(0, twist_input * 100, 0))
	
	#rotate_y(twist_input)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
	
	twist_input = 0
	pitch_input = 0
	
func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity
