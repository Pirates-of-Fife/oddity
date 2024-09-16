extends LaikanCommand

class_name LaikanLookCommand

class Params:
	var twist_input : float
	var pitch_input : float
	
	func _init(twist_input : float, pitch_input : float) -> void:
		self.twist_input = twist_input
		self.pitch_input = pitch_input

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if data is Params and control_entity is Laikan:
		control_entity.look(data.twist_input, data.pitch_input)
