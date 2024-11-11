extends CreatureCommand

class_name  CreatureMovementCommand

class Params:
	var input : Vector2
	
	func _init(input : Vector2) -> void:
		self.input = input

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Creature:
		control_entity.move(data.input)
