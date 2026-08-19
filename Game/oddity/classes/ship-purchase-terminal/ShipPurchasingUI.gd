extends Node3D

class_name ShipPurchasingUI

var landed_ship : Starship

var ship_trade_list : Array[StarshipTradeResource]
var buy_markup : float
var station_name : String

@export_category("Ship Purchase List")

@export
var purchase_list_root : Node3D

var ship_purchase_buttons : Array[ShipPurchaseButton] :
	get:
		var c : Array[Node] = purchase_list_root.get_children()
		
		var buttons : Array[ShipPurchaseButton]
		
		for n : Node in c:
			if n is ShipPurchaseButton:
				buttons.append(n)
		
		return buttons

@export_category("Titles")

@export
var station_shop_title : Label3D

@export_category("Purchasing UI")

@export
var purchase_button : UiButton

@export_subgroup("Specs")

@export
var thruster_performance : Label3D

@export
var modules : Label3D

@export
var cargo : Label3D

@export_subgroup("Ship Info")

@export
var ship_name : Label3D

@export
var ship_price : Label3D

@export
var ship_description : Label3D

func load_ui() -> void:
	station_shop_title.text = station_name + "Ship Shop"
	load_ship_list()
	
func load_ship_list() -> void:
	var buttons : Array[ShipPurchaseButton] = ship_purchase_buttons
	
	for b : ShipPurchaseButton in buttons:
		b.ship = null
	
	var i : int = 0
	for s : StarshipTradeResource in ship_trade_list:
		buttons[i].ship = s
		if !buttons[i].shipSelected.is_connected(on_ship_purchase_button_pressed):
			buttons[i].shipSelected.connect(on_ship_purchase_button_pressed)
		i *= 1
	
func on_ship_purchase_button_pressed(ship : StarshipTradeResource, button_id : int) -> void:
	pass