extends StaticGameEntity

class_name Interactable

signal interacted(player : Player, control_entity : ControlEntity)

@export
var interaction_sound : AudioStreamPlayer3D

@export
var press_delay : float = 0.5

var can_press : bool = true

func interact(player : Player, control_entity : ControlEntity) -> void:
	if interaction_sound != null:
		interaction_sound.play()
		
	if !can_press:
		return
	
	interacted.emit(player, control_entity)
	
	can_press = false
	
	await get_tree().create_timer(press_delay).timeout
	
	can_press = true


	
	
