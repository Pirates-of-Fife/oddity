extends StaticGameEntity

class_name ShipPurchasingTerminal

@export_category("Insurance")

@export
var ship_purchasing_ui : ShipPurchasingUI

@export
var landing_pad : LandingPad

var landed_ship : Starship

@export
var station_pad : StationPad

@export_category("Power")

@export
var terminal_power_on_animation : TradeTerminalPowerOnAnimation

@export
var power_button : TradePowerOnButton

var is_on : bool = false

var ui_scene : String = "res://classes/ship-purchase-terminal/ShipPurchasingUI.tscn"

@onready
var loadout_tools : LoadoutGenerator = LoadoutGenerator.new()

func _ready() -> void:
	landing_pad.starship_landed.connect(_on_ship_landed)
	landing_pad.starship_took_off.connect(_on_ship_took_off)	

	power_button.power_switch_signal.connect(_on_power_switch)
	terminal_power_on_animation.powered_on.connect(_on_power_animation_finished)

func spawn_ship(ship : StarshipTradeResource) -> Starship:
	var starship_scene : PackedScene = load(ship.scene)

	var starship : Starship = starship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	

	get_tree().get_first_node_in_group("StarSystem").add_child(starship)

	starship.is_player_ship = true
	starship.landing_gear_on = true

	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation
	starship.ship_identification = starship.generate_ship_id()
	
	return starship

func store_ship() -> void:
	if landed_ship != null:
		landed_ship.queue_free()

func _on_power_switch() -> void:
	if !is_on:
		terminal_power_on_animation.start_animation(station_pad.station.station_name)
		
		ship_purchasing_ui = load(ui_scene).instantiate()
		ship_purchasing_ui.ready.connect(_on_ui_load)
		ship_purchasing_ui.ship_purchased.connect(spawn_ship)
		ship_purchasing_ui.hide()
		add_child(ship_purchasing_ui)
	else:
		ship_purchasing_ui.hide()
		is_on = false
		ship_purchasing_ui.queue_free()

func _on_ui_load() -> void:
	ship_purchasing_ui.landed_ship = landed_ship
	ship_purchasing_ui.buy_markup = station_pad.station.buy_markup
	ship_purchasing_ui.station_name = station_pad.station.station_name
	ship_purchasing_ui.ship_trade_list = station_pad.station.trade_items.ships_buyable
	
	ship_purchasing_ui.load_ui()
	
func _on_power_animation_finished() -> void:
	ship_purchasing_ui.show()
	is_on = true

func _on_ship_landed(starship : Starship) -> void:
	landed_ship = starship
	
	if ship_purchasing_ui != null:
		ship_purchasing_ui.landed_ship = starship

func _on_ship_took_off(starship : Starship) -> void:
	landed_ship = null
	
	if ship_purchasing_ui != null:
		ship_purchasing_ui.landed_ship = null
