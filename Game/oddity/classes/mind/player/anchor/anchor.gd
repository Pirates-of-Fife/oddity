# @class Anchor
# The player node "anchors" itself to this node.

@icon("res://classes/player/anchor/icons/Anchor.svg")

extends Marker3D

class_name Anchor

var twist_input : float = 0
var pitch_input : float = 0

@export_category("Limits")

@export
var enable_twist_limit : bool = false

@export_range(0, 179, 1, "suffix:°")
var twist_limit : float :
	set(value):
		twist_limit = value
		twist_limit_rad = deg_to_rad(value)

var twist_limit_rad : float

@export
var enable_pitch_limit : bool = false

@export_range(0, 179, 1, "suffix:°")
var pitch_limit : float :
	set(value):
		pitch_limit = value
		pitch_limit_rad = deg_to_rad(value)

var pitch_limit_rad : float

@export_category("Anchor")

@export
var active : bool

@onready
var twist_pivot : Node3D = $TwistPivot

@onready
var pitch_pivot : Node3D = $TwistPivot/PitchPivot

@onready
var camera_anchor : Node3D = $TwistPivot/PitchPivot/CameraAnchor

func look(twist_input : float, pitch_input : float) -> void:
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)

	if enable_pitch_limit:
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -pitch_limit_rad, pitch_limit_rad)

	if enable_twist_limit:
		twist_pivot.rotation.y = clamp(twist_pivot.rotation.y, -twist_limit_rad, twist_limit_rad)

func reset() -> void:
	twist_pivot.rotation = Vector3.ZERO
	pitch_pivot.rotation = Vector3.ZERO
