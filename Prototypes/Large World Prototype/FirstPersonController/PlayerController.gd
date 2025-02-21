extends CharacterBody3D

@export_category("Mouse Settings")
@export
var mouse_sensivity := 0.001

var twist_input := 0.0
var pitch_input := 0.0


@export_category("Speed")

@export
var walking_speed = 3.0

@export
var running_speed = 5.0

@export
var jump_velocity = 4.5

@export_category("Acceleration")

@export
var acceleration = 12

@export
var decceleration = 8.0

@export_category("Camera Pivots")

@export
var twist_pivot : Node3D

@export
var pitch_pivot : Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export
var camera : Camera3D

@onready
var boat = get_parent_node_3d().get_node("Boat")

var is_in_ship : bool = false

var is_on_ship : bool = false

@export_category("Water Physics")
@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready
var water = get_parent_node_3d().get_node("Water")

@onready var probes = $BuyoancyProbes.get_children()

var submerged := false

var last_boat_pos : Vector3

func _physics_process(delta):
	var speed = walking_speed
	
	if submerged:
		speed *= 0.4
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards")
	
	if (Input.is_action_pressed("run")):
		speed = running_speed
	
	var direction = (transform.basis * twist_pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity = direction * speed
	
	if (is_in_ship):
		target_velocity = Vector3.ZERO
	
	if (is_on_floor() or submerged):
		velocity.x = lerp(velocity.x, target_velocity.x, delta * (acceleration if input_dir != Vector2.ZERO else decceleration))
		velocity.z = lerp(velocity.z, target_velocity.z, delta * (acceleration if input_dir != Vector2.ZERO else decceleration))

	if (is_on_ship and is_on_floor() and direction == Vector3.ZERO):
		global_position.x = boat.get_node("ShipHull").global_position.x + last_boat_pos.x
		global_position.z = boat.get_node("ShipHull").global_position.z + last_boat_pos.z
	elif (is_on_ship):
		last_boat_pos = get_position_relative_to_boat()
		
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0 and is_on_ship == false:
			submerged = true
			velocity += Vector3.UP * float_force * gravity * depth
	
	if submerged:
		velocity *=  1 - water_drag
	
	if (water.get_height(camera.global_position) - camera.global_position.y) >= -0.1:
		$Head/TwistPivot/PitchPivot/PlayerCamera/WaterEffect.visible = true
	else:
		$Head/TwistPivot/PitchPivot/PlayerCamera/WaterEffect.visible = false
	
	move_and_slide()
	
# Called when the node enters the scene tree for tshe first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var boat_area = boat.get_node("ShipHull/BoatArea")
	
	boat_area.connect("body_entered", _on_body_entered)
	boat_area.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	is_on_ship = true
	
func _on_body_exited(body):
	is_on_ship = false

func enter_boat():
	camera.current = false
	is_in_ship = true
	
	$InteractableSystem.disabled = true
	
	#global_position = Vector3.ZERO
	
	hide()

func exit_boat():
	camera.current = true
	is_in_ship = false
	
	$InteractableSystem.disabled = false
	
	#global_position = boat.player_spawn_location.global_position
	
	show()

func get_position_relative_to_boat():
	return global_position - boat.get_node("ShipHull").global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
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
