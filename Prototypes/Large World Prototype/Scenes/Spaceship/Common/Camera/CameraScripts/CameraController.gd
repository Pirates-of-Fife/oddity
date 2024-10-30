extends Node3D

## This should be made smoother ##

@export
var mouse_sensivity := 0.001

var twist_input := 0.0
var pitch_input := 0.0

@onready
var twist_pivot := $TwistPivot
@onready
var pitch_pivot := $TwistPivot/PitchPivot

var is_look_around_on : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_look_around_on = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("camera-look-around"):
		if (is_look_around_on):
			is_look_around_on = false
		else:
			is_look_around_on = true
	
	if (is_look_around_on):
		twist_pivot.rotate_y(twist_input)
		pitch_pivot.rotate_x(pitch_input)
		
	twist_input = 0
	pitch_input = 0
	
func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensivity
			pitch_input = - event.relative.y * mouse_sensivity
