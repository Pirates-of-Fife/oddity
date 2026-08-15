extends Control

class_name ShieldAndHullUi

@export_category("Values")
@export
var max_hull_health : float
@export
var current_hull_health : float

@export
var current_shield_health : float
@export
var max_shield_health : float

@export
var current_cooldown : float
@export
var cooldown_time : float

@export_category("Ui")
@export
var hull_health_bar : ProgressBar
@export
var shield_health_bar : ProgressBar
@export
var shield_charge : TextureProgressBar

@export
var shield_health_label : RichTextLabel

@export
var hull_health_label : RichTextLabel

@export
var armour_bar : ProgressBar

@export
var armour_rating : RichTextLabel

var current_armour_health : float
var max_armour_health : float
var current_armour_rating : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hull_health_bar.max_value = max_hull_health
	hull_health_bar.value = current_hull_health

	shield_health_bar.max_value = max_shield_health
	shield_health_bar.value = current_shield_health

	shield_charge.max_value = cooldown_time
	shield_charge.value = cooldown_time
	
	update_armour()

func update_armour() -> void:
	armour_bar.max_value = max_armour_health
	armour_bar.value = current_armour_health
	armour_rating.text = "[center]" + str(roundf(current_armour_rating)) + "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hull_health_bar.max_value = max_hull_health
	hull_health_bar.value = current_hull_health

	shield_health_bar.max_value = max_shield_health
	shield_health_bar.value = current_shield_health

	shield_charge.max_value = cooldown_time
	shield_charge.value = cooldown_time - current_cooldown

	shield_health_label.text = str(roundf(current_shield_health)) + " / " + str(roundf(max_shield_health))
	hull_health_label.text = str(roundf(current_hull_health)) + " / " + str(roundf(max_hull_health))

	if (max_shield_health == 0):
		shield_health_bar.hide()
		shield_charge.hide()
		shield_health_label.hide()
		$ShieldIcon.hide()
	else:
		shield_health_bar.show()
		shield_charge.show()
		shield_health_label.show()
		$ShieldIcon.show()
