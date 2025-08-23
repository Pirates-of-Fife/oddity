extends InteractionButton

class_name TradeItemListItem

signal switch_view(trade_item : TradeResource)

@export
var trade_item : TradeResource

func _ready() -> void:
	interacted.connect(_on_click)
	
	if trade_item != null:
		$Label3D.text = str(trade_item.name)

func _on_click(player : Player, control_entity : ControlEntity) -> void:
	switch_view.emit(trade_item)
