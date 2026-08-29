extends Control

class_name CargoSellingUi2d

@export
var inventory_container : VBoxContainer

@onready
var cargo_label_scene : PackedScene = preload("res://classes/cargo/cargo-selling-ui/CargoLabel.tscn")

@export
var total_credits_label : Label

@export
var total_credits : int

@export
var current_cargo : Array = Array()

@export
var current_modules : Array = Array()

var station_pad : StationPad

var station : SpaceStation : 
	get():
		return station_pad.station

func _ready() -> void:
	reset()

func update(new_cargo : Array, new_modules : Array) -> void:
	current_cargo = new_cargo
	current_modules = new_modules
	calculate_credit_total()
	update_inventory_container()

func reset() -> void:
	total_credits = 0
	current_cargo.clear()
	
	total_credits_label.text = "None"
	
	for i : Control in inventory_container.get_children():
		i.queue_free()

func calculate_credit_total() -> void:
	total_credits = 0
	
	for c : CargoContainer in current_cargo:
		total_credits += c.value * station.sell_markup
	
	for m : GameEntity in current_modules:
		total_credits += m.value * station.sell_markup
	
	var c : CreditHud = CreditHud.new()
	total_credits_label.text = c.convert_to_human_readable(total_credits) + " Credits"

func update_inventory_container() -> void:
	for i : Control in inventory_container.get_children():
		i.queue_free()
		
	for c : CargoContainer in current_cargo:
		var label : CargoLabel = cargo_label_scene.instantiate()
		label.set_cargo_text(c, station.sell_markup)
		inventory_container.add_child(label)
	
	for m : GameEntity in current_modules:
		var label : CargoLabel = cargo_label_scene.instantiate()
		label.set_module_text(m, station.sell_markup)
		inventory_container.add_child(label)
