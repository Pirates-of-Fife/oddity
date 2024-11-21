extends StarshipRotateCommand

class_name StarshipRollLeftCommand

class Params:
	var thrust : float
	
	func _init(thrust : float) -> void:
		self.thrust = thrust

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Starship:
		control_entity.set_target_rotation_roll_left(data.thrust)
