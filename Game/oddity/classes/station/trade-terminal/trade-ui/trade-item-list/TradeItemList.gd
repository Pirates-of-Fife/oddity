extends Node3D

class_name TradeItemList

signal switch_view(trade_item : TradeResource)


var trade_item_list_item_scene : PackedScene = preload("res://classes/station/trade-terminal/trade-ui/trade-item-list-item/TradeItemListItem.tscn")

@export
var height_per_trade_item_list_item : float = 1

@export
var current_trade_item_count : int = 0

func update_trade_item_list(trade_items : Array[TradeResource]) -> void:
	for node : Node3D in get_children():
		node.queue_free()
	
	current_trade_item_count = 0
	
	for trade_item : TradeResource in trade_items:
		var list_item : TradeItemListItem = trade_item_list_item_scene.instantiate()
		list_item.position = Vector3(0, -current_trade_item_count * height_per_trade_item_list_item, 0)
		list_item.trade_item = trade_item
		print(list_item.trade_item)
		list_item.switch_view.connect(_on_click)

		add_child(list_item)
		
		
		current_trade_item_count += 1
		
		print(current_trade_item_count)
		
	
func _on_click(trade_item : TradeResource) -> void:
	switch_view.emit(trade_item)
