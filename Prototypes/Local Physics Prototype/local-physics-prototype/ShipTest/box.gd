extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_released("freeze_test")):
		
		print(" ")
		print("FREEZE TOGGLE " + str(self))
		print(" ")
		
		if (freeze == true):
			freeze = false
			#print("freeze")
		else: 
			freeze = true
