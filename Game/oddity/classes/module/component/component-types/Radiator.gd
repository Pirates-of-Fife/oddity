extends Component

class_name Radiator

func _ready() -> void:
	_radiator_ready()
	
# Radiators will use custom sizes
func _radiator_ready() -> void:
	initialize_collision_shape_automatically = false
	_component_ready()
