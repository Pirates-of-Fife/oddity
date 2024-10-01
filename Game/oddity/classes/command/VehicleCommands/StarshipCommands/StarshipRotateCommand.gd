extends StarshipCommand

class_name  StarshipRotateCommand

class Params:
	var rotation_vector : Vector3
	
	func _init(rotation_vector : Vector3) -> void:
		self.rotation_vector = rotation_vector


func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Starship:
		control_entity.target_rotational_thrust_vector = data.rotation_vector
