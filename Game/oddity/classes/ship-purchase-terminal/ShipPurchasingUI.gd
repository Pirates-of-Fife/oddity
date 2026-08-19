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

signal ship_purchased(ship : StarshipTradeResource)

@export
var purchase_button : UiButton

@export
var ship_information_ui_root : Node3D

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

@export
var logo : Sprite3D

@onready
var credit : CreditHud = CreditHud.new()

@export_category("Preview")

@export
var camera : Camera3D

@export
var preview_ship_root : Node3D

@export_category("Sound")

@export
var success_sound : AudioStreamPlayer3D

@export
var decline_sound : AudioStreamPlayer3D

var selected_button : ShipPurchaseButton

func _ready() -> void:
	purchase_button.interacted.connect(purchase)

func purchase(player : Player, control_entity: ControlEntity) -> void:
	if landed_ship != null:
		decline_sound.play()
		return
		
	if selected_button == null:
		decline_sound.play()
		return
		
	if selected_button.ship == null:
		decline_sound.play()
		return
		
	if player.credits < selected_button.ship.value:
		decline_sound.play()
		return
		
	player.remove_credits(selected_button.ship.value)
	success_sound.play()
	ship_purchased.emit(selected_button.ship)

func load_ui() -> void:
	station_shop_title.text = station_name + " Ship Shop"
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
		i += 1
	
func on_ship_purchase_button_pressed(ship : StarshipTradeResource, button_id : int) -> void:
	for b : ShipPurchaseButton in ship_purchase_buttons:
		if b.id == button_id:
			b.select()
			selected_button = b
		else:
			b.deselect()
		
	display_ship_info(ship)
	
func display_ship_info(ship : StarshipTradeResource) -> void:
	ship_information_ui_root.show()
	
	ship_name.text = ship.name
	ship_description.text = ship.description
	ship_price.text = credit.convert_to_human_readable(ship.value) + "Cr"
	
	cargo.text = str(ship.cargo_capacity) + " CU"
	
	thruster_performance.text = "Forwards: " + str(ship.forwards_accelleration) + " G" + "\n" + \
								"Retro: " + str(ship.retro_accelleration) + " G" + "\n" + \
								"Lateral: " + str(ship.lateral_accelleration) + " G" + "\n" + \
								"Vertical: " + str(ship.vertical_acceleration) + " G" + "\n\n" + \
								"Pitch: " + str(ship.pitch) + " deg/s" + "\n" + \
								"Yaw: " + str(ship.yaw) + " deg/s" + "\n" + \
								"Roll: " + str(ship.roll) + " deg/s"
				
	modules.text = ""
					
	for s : String in ship.component_description:
		modules.text += s + "\n"
	
	logo.texture = ship.manufacturer_logo
	logo.scale = Vector3(ship.logo_scale, ship.logo_scale, ship.logo_scale)
	
	load_preview(ship)
		
func load_preview(ship : StarshipTradeResource) -> void:
	for n : Node in preview_ship_root.get_children():
		n.queue_free()
	
	var ship_scene : PackedScene = load(ship.scene)
	var s : Starship = ship_scene.instantiate()
	s.is_player_ship = false
	
	preview_ship_root.add_child(s)
	
	camera.position.z = ship.preview_distance