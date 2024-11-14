extends StarshipCommand

class_name StarshipDecreaseMaxVelocity

class Params:
	var decrease_velocity : float
	
	func _init(decrease_velocity : float) -> void:
		self.decrease_velocity = decrease_velocity

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Starship:
		control_entity.decrease_max_velocity(data.decrease_velocity)
