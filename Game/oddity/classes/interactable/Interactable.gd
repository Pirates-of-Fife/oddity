extends StaticGameEntity

class_name Interactable

signal interacted(player : Player, control_entity : ControlEntity)

@export
var interaction_sound : AudioStreamPlayer3D

@export
var press_delay : float = 0.5

@export
var skip_delay : bool = false

var can_press : bool = true

func interact(player : Player, control_entity : ControlEntity) -> void:
	if interaction_sound != null:
		interaction_sound.play()
		
	if !can_press:
		return
	
	interacted.emit(player, control_entity)
	
	if skip_delay:
		return
	
	can_press = false
	
	await get_tree().create_timer(press_delay).timeout
	
	can_press = true


	
	
