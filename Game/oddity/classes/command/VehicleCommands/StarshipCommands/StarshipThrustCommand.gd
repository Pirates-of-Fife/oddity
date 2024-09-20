extends StarshipCommand

class_name  StarshipThrustCommand

class Params:
	var thrust_vector : Vector3
	
	func _init(thrust_vector : Vector3) -> void:
		self.thrust_vector = thrust_vector

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Starship:
		# set thrust vector
		pass
