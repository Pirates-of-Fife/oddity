extends Component

class_name ShieldGenerator

@export_category("Shield")

@export
var current_health : float

@export
var ship_shield_static_body : Shield

func _ready() -> void:
	_shield_generator_ready()
	
func _shield_generator_ready() -> void:
	_component_ready()
	
func _on_insert(slot : ModuleSlot) -> void:
	if slot.vehicle == null:
		return
	
	ship_shield_static_body = slot.vehicle.shield

func _on_uninsert(slot : ModuleSlot) -> void:

	ship_shield_static_body = null
