extends Node3D

class_name InsuranceUi

@export_category("Insurance Info")

@export_range(0, 1, 0.01)
var insurance_percentage : float = 0

@export
var price_markup : float = 0

@export_category("Ship")

@export
var landed_ship : Starship : 
	set(value):
		if value == null:
			landed_ship_name_label.hide()
			landed_ship_id_label.hide()
			landed_ship = value
			return
			
		landed_ship_name_label.show()
		landed_ship_id_label.show()
		
		landed_ship_name_label.text = value.ship_name
		landed_ship_id_label.text = value.ship_identification
		
		landed_ship = value
	get:
		return landed_ship

@export
var landed_ship_name_label : Label3D

@export
var landed_ship_id_label : Label3D

@export_category("Tabs")

@export
var insurance_tab : UiButton

@export
var storage_tab : UiButton

@export_category("Insurance UI")

signal ship_claimed(loadout : StarshipLoadout)

@export
var insurance_ui_root : Node3D

@export
var insurance_slots_root : Node3D

var insurance_slots : Array[LoadoutSlotButton] :
	get:
		var nodes : Array[Node] = insurance_slots_root.get_children()
		var slots : Array[LoadoutSlotButton]
		
		for n : Node in nodes:
			if n is LoadoutSlotButton:
				slots.append(n)
		
		return slots

@export
var delete_insurance_button : UiButton

@export
var insure_button : UiButton

@export
var override_insurance_button : UiButton

@export
var claim_insurance_button : UiButton

@export
var selected_insurance_ship_name_label : Label3D

@export
var selected_insurance_price_label : Label3D

var selected_insurance_button : LoadoutSlotButton

@export_category("Storage UI")

signal ship_retrieved(loadout : StarshipLoadout)
signal ship_stored

@export
var storage_ui_root : Node3D

@export
var storage_slots_root : Node3D

var storage_slots : Array[LoadoutSlotButton] :
	get:
		var nodes : Array[Node] = storage_slots_root.get_children()
		var slots : Array[LoadoutSlotButton]
		
		for n : Node in nodes:
			if n is LoadoutSlotButton:
				slots.append(n)
		
		return slots

@export
var store_button : UiButton

@export
var retrieve_button : UiButton

@export
var sell_button : UiButton

@export
var selected_stored_ship_name_label : Label3D

@export
var selected_stored_ship_id_label : Label3D

@export
var selected_stored_ship_value_label : Label3D

var selected_storage_button : LoadoutSlotButton

@export_category("Sound")

@export
var success_sound : AudioStreamPlayer3D

@export
var decline_sound : AudioStreamPlayer3D

@onready
var caretaker : Caretaker = get_tree().get_first_node_in_group("World").caretaker

@onready
var credit_hud : CreditHud = CreditHud.new()

@onready
var loadout_tools : LoadoutGenerator = LoadoutGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	insure_button.interacted.connect(insure_ship)
	override_insurance_button.interacted.connect(override_insurance)
	claim_insurance_button.interacted.connect(claim_ship)
	delete_insurance_button.interacted.connect(delete_insurance)
	
	store_button.interacted.connect(store_ship)
	retrieve_button.interacted.connect(retrieve_ship)
	sell_button.interacted.connect(sell_ship)
	
	insurance_tab.interacted.connect(on_insurance_tab_clicked)
	storage_tab.interacted.connect(on_storage_tab_clicked)
	
	load_storage_slots()
	
func on_insurance_tab_clicked(player : Player, control_entity: ControlEntity) -> void:
	storage_ui_root.hide()
	insurance_ui_root.show()
	insurance_tab.select()
	storage_tab.deselect()
	selected_storage_button = null
	selected_insurance_button = null
	
	storage_ui_root.position.y = 1000000000
	insurance_ui_root.position.y = 0.716
	
	load_insurance_slots()
	
func on_storage_tab_clicked(player : Player, control_entity: ControlEntity) -> void:
	storage_ui_root.show()
	insurance_ui_root.hide()
	insurance_tab.deselect()
	storage_tab.select()
	selected_storage_button = null
	selected_insurance_button = null
	
	storage_ui_root.position.y = 0
	insurance_ui_root.position.y = 1000000000
	
	load_storage_slots()
	
func delete_insurance(player : Player, control_entity: ControlEntity) -> void:
	selected_insurance_button.loadout = null
	save_insurance_slots()
	load_insurance_slots()

func insure_ship(player : Player, control_entity: ControlEntity) -> void:
	if landed_ship == null:
		return
	
	selected_insurance_button.loadout = loadout_tools.save_loadout(landed_ship)
	save_insurance_slots()
	load_insurance_slots()
	
func override_insurance(player : Player, control_entity: ControlEntity) -> void:
	if landed_ship == null:
		return
	
	selected_insurance_button.loadout = loadout_tools.save_loadout(landed_ship)
		
func claim_ship(player : Player, control_entity: ControlEntity) -> void:
	if landed_ship:
		decline_sound.play()
		return
		
	if player.credits < get_insurance_price(selected_insurance_button.loadout):
		decline_sound.play()
		return
	
	player.remove_credits(get_insurance_price(selected_insurance_button.loadout))
	ship_claimed.emit(selected_insurance_button.loadout)
	
	success_sound.play()
	
func on_insurance_slot_pressed(loadout : StarshipLoadout, button_id : int) -> void:
	for button : LoadoutSlotButton in insurance_slots:
		button.deselect()
		
		if button.id == button_id:
			button.select()
			selected_insurance_button = button
	
	if loadout == null:
		if landed_ship != null:
			insure_button.show()
			
		delete_insurance_button.hide()
		claim_insurance_button.hide()
		override_insurance_button.hide()
		
		selected_insurance_price_label.hide()
		selected_insurance_ship_name_label.hide()
	else:
		
		insure_button.hide()
		delete_insurance_button.show()
		claim_insurance_button.show()
		
		if landed_ship != null:
			override_insurance_button.show()
			
		selected_insurance_price_label.show()
		selected_insurance_ship_name_label.show()
		
		selected_insurance_price_label.text = credit_hud.convert_to_human_readable(get_insurance_price(loadout))
		selected_insurance_ship_name_label.text = loadout.ship_name
		
func load_insurance_slots() -> void:
	var insurance : Array[StarshipLoadout] = caretaker.get_save_file().insured_ships
	
	var i : int = 0
	
	for button : LoadoutSlotButton in insurance_slots:
		if !button.loadoutSelected.is_connected(on_insurance_slot_pressed):
			button.loadoutSelected.connect(on_insurance_slot_pressed)
		button.deselect()
		
		if insurance[i] == null:
			continue
		
		button.loadout = insurance[i]
		
		i += 1
		
		insure_button.hide()
			
		delete_insurance_button.hide()
		claim_insurance_button.hide()
		override_insurance_button.hide()
		
		selected_insurance_price_label.hide()
		selected_insurance_ship_name_label.hide()
			
func save_insurance_slots() -> void:
	var insurance : Array[StarshipLoadout]
	insurance.resize(10)
	insurance.fill(null)

	var i : int = 0
	
	for button : LoadoutSlotButton in insurance_slots:	
		insurance[i] = button.loadout
		
		i += 1

	caretaker.update_insured_ships(insurance)
	
func get_insurance_price(loadout : StarshipLoadout) -> int:
	return loadout.value * insurance_percentage * price_markup

func get_sell_price(loadout : StarshipLoadout) -> int:
	return loadout.value * 0.1

func load_storage_slots() -> void:
	var storage : Array[StarshipLoadout] = caretaker.get_save_file().stored_ships
	
	var i : int = 0
	
	for button : LoadoutSlotButton in storage_slots:
		if !button.loadoutSelected.is_connected(on_storage_slot_pressed):
			button.loadoutSelected.connect(on_storage_slot_pressed)
		button.deselect()
		
		if storage[i] == null:
			continue
		
		button.loadout = storage[i]
		
		i += 1

	store_button.hide()
	retrieve_button.hide()
	selected_stored_ship_id_label.hide()
	selected_stored_ship_name_label.hide()
	selected_stored_ship_value_label.hide()
	sell_button.hide()
	
func save_storage_slots() -> void:
	var storage : Array[StarshipLoadout]
	storage.resize(10)
	storage.fill(null)

	var i : int = 0
	
	for button : LoadoutSlotButton in storage_slots:	
		storage[i] = button.loadout
		
		i += 1

	caretaker.update_stored_ships(storage)

func on_storage_slot_pressed(loadout : StarshipLoadout, button_id : int) -> void:
	for button : LoadoutSlotButton in storage_slots:
		button.deselect()
		
		if button.id == button_id:
			button.select()
			selected_storage_button = button
	
	if loadout == null:
		selected_stored_ship_id_label.hide()
		selected_stored_ship_name_label.hide()
		selected_stored_ship_value_label.hide()
		
		sell_button.hide()
		
		if landed_ship == null:
			store_button.hide()
			retrieve_button.hide()
		else:
			store_button.show()
			retrieve_button.hide()
	else:
		if landed_ship == null:
			store_button.hide()
			retrieve_button.show()
		else:
			store_button.hide()
			retrieve_button.hide()
		
		sell_button.show()
		
		selected_stored_ship_id_label.show()
		selected_stored_ship_name_label.show()
		selected_stored_ship_value_label.show()
		
		selected_stored_ship_value_label.text = credit_hud.convert_to_human_readable(get_sell_price(selected_storage_button.loadout))
		selected_stored_ship_name_label.text = loadout.ship_name
		selected_stored_ship_id_label.text = loadout.ship_identification
		
func retrieve_ship(player : Player, control_entity: ControlEntity) -> void:
	if selected_storage_button.loadout == null:
		decline_sound.play()
		return
	
	if landed_ship != null:
		decline_sound.play()
		return
		
	ship_retrieved.emit(selected_storage_button.loadout)
	success_sound.play()

	selected_storage_button.loadout = null

	save_storage_slots()
	load_storage_slots()
	
func store_ship(player : Player, control_entity: ControlEntity) -> void:
	if selected_storage_button.loadout != null:
		decline_sound.play()
		return
	
	if landed_ship == null:
		decline_sound.play()
		return
	
	selected_storage_button.loadout = loadout_tools.save_loadout(landed_ship, true, true)
	
	ship_stored.emit()
	success_sound.play()
	
	save_storage_slots()
	load_storage_slots()

func sell_ship(player : Player, control_entity: ControlEntity) -> void:
	if selected_storage_button.loadout == null:
		decline_sound.play()
		return
	
	player.remove_credits(get_sell_price(selected_storage_button.loadout))
	selected_storage_button.loadout = null

	success_sound.play()
	
	save_storage_slots()
	load_storage_slots()
