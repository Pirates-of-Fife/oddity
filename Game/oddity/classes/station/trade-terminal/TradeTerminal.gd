extends StaticGameEntity

class_name TradeTerminal

var is_on : bool = false

@export
var station_pad : StationPad

var station : SpaceStation :
	get:
		return station_pad.station

var station_name : String :
	get:
		return station_pad.station.station_name

var trade_items : Array[TradeResource] :
	get:
		return station_pad.station.trade_items

@export
var ui : Node3D

@export
var power_button : TradePowerOnButton

@export
var trade_terminal_power_on_animation : TradeTerminalPowerOnAnimation

func _ready() -> void:
	power_button.power_switch_signal.connect(_on_power_switch)
	trade_terminal_power_on_animation.powered_on.connect(_on_power_animation_finished)

func _on_power_switch() -> void:
	if !is_on:
		trade_terminal_power_on_animation.start_animation(station_name)
	else:
		ui.hide()
		is_on = false
		
func _on_power_animation_finished() -> void:
	ui.show()
	is_on = true
