extends StaticGameEntity

class_name TradeTerminal

var is_on : bool = false

@export
var station_pad : StationPad

var trade_terminal_ui_scene : PackedScene = preload("res://classes/station/trade-terminal/trade-ui/TradeTerminalUi.tscn")

var station : SpaceStation :
	get:
		return station_pad.station

var station_name : String :
	get:
		return station_pad.station.station_name

var trade_items : Array[TradeResource] :
	get:
		return station_pad.station.trade_items.trade_resources

var ui : TradeTerminalUi

@export
var power_button : TradePowerOnButton

@export
var trade_terminal_power_on_animation : TradeTerminalPowerOnAnimation

var selected_trade_item : TradeResource
var buy_price : int = 0

@export
var cargo_grid : CargoGrid

@export
var module_spawn_position_marker : Marker3D


func _ready() -> void:
	power_button.power_switch_signal.connect(_on_power_switch)
	trade_terminal_power_on_animation.powered_on.connect(_on_power_animation_finished)

func _on_ui_load() -> void:
	pass
		
func _on_ui_unload() -> void:
	pass

func _on_power_switch() -> void:
	if !is_on:
		trade_terminal_power_on_animation.start_animation(station_name)
		ui = trade_terminal_ui_scene.instantiate()
		
		ui.cargo_grid = cargo_grid
		ui.station_buy_markup = station_pad.station.buy_markup
		ui.station_name = station_pad.station.station_name
		ui.module_spawn_position_marker = module_spawn_position_marker
		ui.trade_items = station_pad.station.trade_items.trade_resources
		
		
		ui.ready.connect(_on_ui_load)
		ui.tree_exiting.connect(_on_ui_unload)
		ui.hide()
		
		add_child(ui)
	else:
		ui.hide()
		is_on = false
		ui.queue_free()
		
func _on_power_animation_finished() -> void:
	ui.show()
	is_on = true
