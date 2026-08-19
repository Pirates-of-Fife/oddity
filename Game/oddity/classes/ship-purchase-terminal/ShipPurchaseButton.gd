extends UiButton

class_name ShipPurchaseButton

@export
var starship : StarshipTradeResource

@export
var id : int

@export_category("Ship")

@export
var ship : StarshipTradeResource :
	set(value):
		ship = value
		
		if value == null:
			hide()
			collision_layer = 0
			collision_mask = 0
		else:
			button_text = ship.name
			show()
			set_collision_layer_value(30, true)
			set_collision_mask_value(30, true)
	get:
		return ship

signal shipSelected(ship : StarshipTradeResource, button_id : int)

func _ready() -> void:
	super._ready()
	
	interacted.connect(_on_interacted)
	
func _on_interacted(player : Player, control_entity: ControlEntity) -> void:
	shipSelected.emit(ship, id)
