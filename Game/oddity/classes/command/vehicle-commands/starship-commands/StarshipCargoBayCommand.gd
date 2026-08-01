extends StarshipCommand

class_name StarshipCargoBayCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		control_entity.toggle_cargo_bay()