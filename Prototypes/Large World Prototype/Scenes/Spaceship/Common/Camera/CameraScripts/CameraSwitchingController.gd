extends Node3D

signal set_default_position(defaultPosition : Vector3)
signal is_first_person_signal(is_first_person : bool)

@onready
var camera = $CameraPivots/TwistPivot/PitchPivot/Camera3D

@onready
var animation = $SubViewportContainer2/SubViewport/Camera3D2/CameraViewSwitchAnimator

var is_first_person = true

@export_category("Camera Positions")

# This should eventually be changed to be dynamic and such with the animations
# But i have no idea how to do that currently

@export
var first_person_position : Vector3

@export
var third_person_position : Vector3

func _input(event):	
	if Input.is_action_just_pressed("camera-switch-view"):
		
		if (is_first_person and not animation.is_playing()):
		
			animation.play("SwitchCameraToThirdPersonView")
			
			set_default_position.emit(third_person_position)
			is_first_person = false
			is_first_person_signal.emit(is_first_person)
			
		elif (not is_first_person and not animation.is_playing()):
			
			animation.play_backwards("SwitchCameraToThirdPersonView")
			
			is_first_person = true
			set_default_position.emit(first_person_position)
			is_first_person_signal.emit(is_first_person)
