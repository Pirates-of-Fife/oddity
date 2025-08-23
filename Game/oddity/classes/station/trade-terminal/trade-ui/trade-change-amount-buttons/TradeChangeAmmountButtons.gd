extends Node3D

class_name TradeChangeAmmountButtons

signal counter_changed(counter : int)

var counter : int :
	set(value):
		if value < 1:
			$Decline.play()
			return
		if value > 30:
			$Decline.play()
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
