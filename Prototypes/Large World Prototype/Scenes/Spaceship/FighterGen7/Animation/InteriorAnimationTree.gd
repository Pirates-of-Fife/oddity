extends AnimationTree

var movement_vector : Vector3
var rotation_vector : Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set("parameters/Throttle/add_amount", -movement_vector.z * 4)
	set("parameters/Roll/add_amount", rotation_vector.z * 4)
	set("parameters/Pitch/add_amount", -rotation_vector.x * 4)
	set("parameters/Yaw/add_amount", rotation_vector.y * 4) 

func _on_player_input_send_movement_vector(movement_vector):
	self.movement_vector = movement_vector


func _on_player_input_send_rotation_vector(rotation_vector):
	self.rotation_vector = rotation_vector
