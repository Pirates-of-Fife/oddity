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
var error_label : Label3D

@export
var success_label : Label3D

@export
var module_spawn_position_marker : Marker3D


func _ready() -> void:
	power_button.power_switch_signal.connect(_on_power_switch)
	trade_terminal_power_on_animation.powered_on.connect(_on_power_animation_finished)


func _on_ui_load() -> void:
	ui.trade_item_list.switch_view.connect(trade_item_selected)
	load_trade_item_list()
	ui.trade_change_ammount_buttons.counter_changed.connect(calculate_item_price)
	ui.trade_terminal_buy_button.interacted.connect(buy)
	
func _on_ui_unload() -> void:
	pass

func _on_power_switch() -> void:
	if !is_on:
		trade_terminal_power_on_animation.start_animation(station_name)
		ui = trade_terminal_ui_scene.instantiate()
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

func trade_item_selected(trade_item : TradeResource) -> void:
	ui.trade_item_information_screen.display_trade_item(trade_item, station.buy_markup)
	selected_trade_item = trade_item
	calculate_item_price()

func load_trade_item_list() -> void:
	ui.trade_item_list.update_trade_item_list(trade_items)
	
func calculate_item_price(data : Variant = null) -> void:
	if selected_trade_item == null:
		return
	
	buy_price = selected_trade_item.value * station.buy_markup * ui.trade_change_ammount_buttons.counter
	ui.trade_credit_label.credits = buy_price

	
func buy(player : Player, control_entity : ControlEntity) -> void:
	if !buy_check(player):
		return
	
	player.remove_credits(buy_price)
	show_success("Successfully bought " + str(ui.trade_change_ammount_buttons.counter) + " " + selected_trade_item.name)

	for i : int in range(ui.trade_change_ammount_buttons.counter):
		var trade_item_scene : PackedScene = load(selected_trade_item.scene)
		var trade_item : GameEntity = trade_item_scene.instantiate()
		get_tree().get_first_node_in_group("World").add_child(trade_item)
		
		if trade_item is CargoContainer:
			cargo_grid.add_cargo_container(trade_item)
			trade_item.value = selected_trade_item.value
		else:
			trade_item.global_position = module_spawn_position_marker.global_position
		
		await get_tree().create_timer(0.1).timeout
		
	
func buy_check(player : Player) -> bool:
	if selected_trade_item == null:
		show_error("nothing selected")
		return false
	
	if player.credits < buy_price:
		show_error("not enough credits")
		return false
	
	if selected_trade_item is CargoContainerTradeResource:
		if ui.trade_change_ammount_buttons.counter > cargo_grid.cargo_areas_left:
			show_error("not enough room in cargo grid. only " + str(cargo_grid.cargo_areas_left) + " available.")
			return false
	
	if selected_trade_item is ModuleTradeResource:
		if ui.trade_change_ammount_buttons.counter > 10:
			show_error("can't buy more than 10 modules at once")
			return false
			
	return true
	
func show_error(message : String) -> void:
	error_label.text = message.to_upper()
	error_label.show()
	ui.error_noise.play()
	await get_tree().create_timer(1).timeout
	error_label.hide()

func show_success(message : String) -> void:
	success_label.text = message.to_upper()
	success_label.show()
	await get_tree().create_timer(1).timeout
	success_label.hide()
