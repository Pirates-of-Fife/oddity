extends Node3D

class_name TradeTerminalUi

@export_category("Trade Items")

@export
var trade_item_root : Node3D

@export_category("Buttons")

@export
var ammount_buttons : TradeChangeAmmountButtons

@export
var trade_terminal_buy_button : InteractionButton

@export
var trade_change_ammount_buttons : TradeChangeAmmountButtons

@export
var previous_button : UiButton

@export
var next_button : UiButton

@export_category("Labels")

@export
var page_label : Label3D

@export
var title_label : Label3D

@export
var trade_credit_label : TradeCreditLabel

@export
var error_label : Label3D

@export
var success_label : Label3D

@export_category("Screens")

@export
var trade_item_information_screen : TradeItemInformationScreen

@export_category("Sound")

@export
var error_noise : AudioStreamPlayer3D

var cargo_grid : CargoGrid
var module_spawn_position_marker : Marker3D

var station_name : String
var station_buy_markup : float

var item_ammount : int = 1

var selected_trade_button : TradeItemButton

var trade_items : Array[TradeResource]

var items_per_screen : int = 10

var current_page : int = 1 :
	set(value):
		print(value)
	
		if value <= 0:
			current_page = 1
			return
		if value > max_pages:
			current_page = max_pages
			return
			
		current_page = value
	get:
		return current_page
	
var max_pages : int :
	get:
		return trade_items.size() / items_per_screen + 1

var trade_items_on_current_page : Array[TradeResource]:
	get:
		var items : Array[TradeResource]
		items.resize(items_per_screen)
		items.fill(null)
		
		var start_index : int = (current_page - 1) * items_per_screen
		var end_index : int = mini(trade_items.size(), start_index + items_per_screen)

		for i : int in range(end_index - start_index):
			items[i] = (trade_items[start_index + i])
		
		return items

func _ready() -> void:
	next_button.interacted.connect(on_next)
	previous_button.interacted.connect(on_previous)
	
	title_label.text = station_name + " Trading Terminal"
	
	trade_terminal_buy_button.interacted.connect(buy)
	
	ammount_buttons.counter_changed.connect(on_counter_changed)
	
	for button : Node in trade_item_root.get_children():
		if button is TradeItemButton:
			button.itemSelected.connect(on_item_selected)
	
	update_pagination()
	update_trade_items()
	clear_selection()
	
func on_next(player : Player, control_entity : ControlEntity) -> void:
	current_page += 1
	
	update_pagination()
	update_trade_items()
	clear_selection()
	
func on_previous(player : Player, control_entity : ControlEntity) -> void:
	current_page -= 1
	
	update_pagination()
	update_trade_items()
	clear_selection()

func update_trade_items() -> void:
	var items : Array[TradeResource] = trade_items_on_current_page
	
	var i : int = 0
	for button : Node in trade_item_root.get_children():
		if button is TradeItemButton:
			button.trade_item = items[i]
			i += 1

func update_pagination() -> void:
	page_label.text = str(current_page) + " / " + str(max_pages)

func on_item_selected(trade_item : TradeResource, button_id : int) -> void:
	trade_item_information_screen.hide()
	
	for button : Node in trade_item_root.get_children():
		if button is TradeItemButton:
			if button.id == button_id:
				button.select()
				selected_trade_button = button
				
				if selected_trade_button.trade_item != null:
					trade_credit_label.credits = selected_trade_button.trade_item.value * station_buy_markup * item_ammount
					trade_credit_label.show()
					trade_item_information_screen.display_trade_item(selected_trade_button.trade_item, station_buy_markup)
					trade_item_information_screen.show()
			else:
				button.deselect()
				

func clear_selection() -> void:
	selected_trade_button = null

	for button : Node in trade_item_root.get_children():
		if button is TradeItemButton:
			button.deselect()
			trade_credit_label.hide()
			trade_item_information_screen.hide()
				
func buy(player : Player, control_entity : ControlEntity) -> void:
	if !buy_check(player):
		return
	
	player.remove_credits(selected_trade_button.trade_item.value * station_buy_markup)
	show_success("Successfully bought " + str(trade_change_ammount_buttons.counter) + " " + selected_trade_button.trade_item.name)

	for i : int in range(trade_change_ammount_buttons.counter):
		var trade_item_scene : PackedScene = load(selected_trade_button.trade_item.scene)
		var trade_item : GameEntity = trade_item_scene.instantiate()
		get_tree().get_first_node_in_group("World").add_child(trade_item)
	
		if trade_item is CargoContainer:
			cargo_grid.add_cargo_container(trade_item)
			trade_item.value = selected_trade_button.trade_item.value
		else:
			trade_item.global_position = module_spawn_position_marker.global_position
		
		await get_tree().create_timer(0.1).timeout
		
	
func buy_check(player : Player) -> bool:
	if selected_trade_button.trade_item == null:
		show_error("nothing selected")
		return false
	
	if player.credits < selected_trade_button.trade_item.value * station_buy_markup:
		show_error("not enough credits")
		return false
	
	if selected_trade_button.trade_item is CargoContainerTradeResource:
		if trade_change_ammount_buttons.counter > cargo_grid.cargo_areas_left:
			show_error("not enough room in cargo grid. only " + str(cargo_grid.cargo_areas_left) + " available.")
			return false
	
	if selected_trade_button.trade_item is ModuleTradeResource:
		if trade_change_ammount_buttons.counter > 10:
			show_error("can't buy more than 10 modules at once")
			return false
			
	return true
	
func show_error(message : String) -> void:
	error_label.text = message.to_upper()
	error_label.show()
	error_noise.play()
	await get_tree().create_timer(1).timeout
	error_label.hide()

func show_success(message : String) -> void:
	success_label.text = message.to_upper()
	success_label.show()
	await get_tree().create_timer(1).timeout
	success_label.hide()

func on_counter_changed(counter : int) -> void:
	item_ammount = counter
	
	if selected_trade_button == null:
		return
	
	if selected_trade_button.trade_item == null:
		return
		
	trade_credit_label.credits = selected_trade_button.trade_item.value * station_buy_markup * item_ammount
