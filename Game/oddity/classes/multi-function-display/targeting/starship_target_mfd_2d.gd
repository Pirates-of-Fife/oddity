extends Control

class_name StarshipTargetMfd2d

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
var ship_name : RichTextLabel

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

@export_category("Displays")
@export
var ship_focused_display : Control

@export
var no_target_display : Control

func update_target_info(starship : Starship) -> void:
	ship_focused_display.show()
	no_target_display.hide()

	max_hull_health = starship.max_hull_health
	current_hull_health = starship.current_hull_health
	current_shield_health = starship.shield_current_health
	max_shield_health = starship.shield_max_health
	cooldown_time = starship.shield_cooldown_after_break
	current_cooldown = starship.shield_cooldown_after_break_timer.time_left

	hull_health_bar.max_value = max_hull_health
	hull_health_bar.value = current_hull_health

	shield_health_bar.max_value = max_shield_health
	shield_health_bar.value = current_shield_health

	shield_charge.max_value = cooldown_time
	shield_charge.value = cooldown_time - current_cooldown

	shield_health_label.text = str(roundf(current_shield_health)) + " / " + str(roundf(max_shield_health))
	hull_health_label.text = str(roundf(current_hull_health)) + " / " + str(roundf(max_hull_health))

	ship_name.text = starship.ship_name

	if (max_shield_health == 0):
		shield_health_bar.hide()
		shield_charge.hide()
		shield_health_label.hide()
		$ShipFocused/ShieldIcon.hide()
	else:
		shield_health_bar.show()
		shield_charge.show()
		shield_health_label.show()
		$ShipFocused/ShieldIcon.show()

func unfocus() -> void:
	ship_focused_display.hide()
	no_target_display.show()
