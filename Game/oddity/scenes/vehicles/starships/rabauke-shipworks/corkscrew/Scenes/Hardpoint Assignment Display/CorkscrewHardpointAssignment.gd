extends Node3D

@export
var left_wing_left : Hardpoint

@export
var left_wing_right : Hardpoint

@export
var right_wing_left : Hardpoint

@export
var right_wing_right : Hardpoint

@export
var ship : Starship

func _ready() -> void:
	ship.ready.connect(_ship_ready)

func _ship_ready() -> void:
	$LeftWingLeft.hardpoint = left_wing_left
	$LeftWingRight.hardpoint = left_wing_right
	$RightWingLeft.hardpoint = right_wing_left
	$RightWingRight.hardpoint = right_wing_right

	$LeftWingLeft.set_ready()
	$LeftWingRight.set_ready()
	$RightWingLeft.set_ready()
	$RightWingRight.set_ready()
