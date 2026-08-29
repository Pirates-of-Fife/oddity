extends UiButton

class_name TradeItemButton

@export
var id : int = 0

@export_category("Loadout")

@export
var trade_item : TradeResource :
	set(value):
		trade_item = value
		
		if value == null:
			button_text = "EMPTY"
		else:
			button_text = trade_item.name
	get:
		return trade_item

signal itemSelected(trade_item : TradeResource, button_id : int)

func _ready() -> void:
	super._ready()
	
	interacted.connect(_on_interacted)
	
	button_text = "EMPTY"

func _on_interacted(player : Player, control_entity: ControlEntity) -> void:
	itemSelected.emit(trade_item, id)