extends Node3D

class_name TradeChangeAmmountButtons

signal counter_changed(counter : int)

@export_range(0, 99, 1)
var min_value : int = 1

@export_range(0, 99, 1)
var max_value : int = 30

var counter : int = 1 :
	set(value):
		if value < min_value:
			play_decline_sound()
			return
		if value > max_value:
			play_decline_sound()
			return
		
		counter = value
		
		counter_label.text = str(counter)
		
		counter_changed.emit(counter)
	get:
		return counter

@export
var counter_label : Label3D

@export
var add_button : InteractionButton

@export
var remove_button : InteractionButton

func _ready() -> void:
	add_button.interacted.connect(_add)
	remove_button.interacted.connect(_remove)

func _add(player : Player, control_entity : ControlEntity) -> void:
	counter += 1
	
func _remove(player : Player, control_entity : ControlEntity) -> void:
	counter -= 1

func play_decline_sound() -> void:
	$Decline.play()
