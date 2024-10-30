extends StaticGameEntity

class_name Interactable

signal interacted(player : Player, control_entity : ControlEntity)

func interact(player : Player, control_entity : ControlEntity) -> void:
	interacted.emit(player, control_entity)
	
