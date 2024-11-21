extends StarshipCommand

class_name StarshipIncreaseMaxVelocityCommand

class Params:
	var increase_velocity : float
	
	func _init(increase_velocity : float) -> void:
		self.increase_velocity = increase_velocity

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Starship:
		control_entity.increase_max_velocity(data.increase_velocity)
