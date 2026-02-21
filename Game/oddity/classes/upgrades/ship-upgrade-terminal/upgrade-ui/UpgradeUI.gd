extends Node3D

class_name UpgradeUI

var max_upgrade_reached : bool : 
	get():
		return max_upgrade_reached
	set(value):
		if value == false:
			max_upgrade_reached = value
			_next_multiplier_label.show()
			_price_label.show()
			return
		
		_next_multiplier_label.hide()
		_price_label.hide()

var upgrade_name : String:
	get:
		return upgrade_name
	set(value):
		upgrade_name = value
		if _name_label:
			_name_label.text = value


var upgrade_description : String:
	get:
		return upgrade_description
	set(value):
		upgrade_description = value
		if _description_label:
			_description_label.text = value


var upgrade_current_multiplier : float:
	get:
		return upgrade_current_multiplier
	set(value):
		upgrade_current_multiplier = value
		if _current_multiplier_label:
			_current_multiplier_label.text = str(value) + "X"


var upgrade_next_multiplier : float:
	get:
		return upgrade_next_multiplier
	set(value):
		upgrade_next_multiplier = value
		if _next_multiplier_label:
			_next_multiplier_label.text = str(value) + "X"

var upgrade_price : int:
	get:
		return upgrade_price
	set(value):
		upgrade_price = value
		if _price_label:
			var credit_hud : CreditHud = CreditHud.new()
			_price_label.text = credit_hud.convert_to_human_readable(value) + " Cr"

var current_upgrade_level : int :
	get:
		return current_upgrade_level
	set(value):
		current_upgrade_level = value
		_counter.initialize_counter(value)

var max_upgrade_level : int :
	get:
		return max_upgrade_level
	set(value):
		max_upgrade_level = value
		_counter.max_value = value

@export
var _price_label : Label3D

@export
var _description_label : Label3D

@export
var _name_label : Label3D

@export
var _current_multiplier_label : Label3D

@export
var _next_multiplier_label : Label3D

@export
var _counter : UpgradeButton

signal upgrade

func _ready() -> void:
	_counter.counter_changed.connect(_on_upgrade)

func _on_upgrade(level : int) -> void:
	upgrade.emit()
