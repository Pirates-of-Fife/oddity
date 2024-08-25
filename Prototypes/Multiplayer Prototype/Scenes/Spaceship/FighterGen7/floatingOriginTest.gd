extends Node3D

@onready
var rb = $ShipBody

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _enter_tree():
	#set_multiplayer_authority(name.to_int())
	#$ShipBody/Cameras/CameraPivots/TwistPivot/PitchPivot/Camera3D.current = is_multiplayer_authority()
