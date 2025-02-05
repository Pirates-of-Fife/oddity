extends StaticGameEntity

class_name Interactable

signal interacted(player : Player, control_entity : ControlEntity)

@export
var interaction_sound : AudioStreamPlayer3D

func interact(player : Player, control_entity : ControlEntity) -> void:
	interacted.emit(player, control_entity)
	
	if interaction_sound != null:
		interaction_sound.play()
