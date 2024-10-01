extends Interactable

# WARNING: TEMP CODE

@export
var starship : Starship 

var entity_using_seat : ControlEntity

var entity_parent : Node3D

func interact(player : Player, control_entity : ControlEntity) -> void:
	interacted.emit(player, control_entity)
	
	entity_using_seat = control_entity
	
	player.possess(starship)
	
	print("Enter")
	
	#entity_parent = control_entity.get_parent_node_3d()
	#control_entity.reparent(starship)

func _on_interactable_interacted(player: Player, control_entity : ControlEntity) -> void:
	#control_entity.reparent(entity_parent)
	player.possess(entity_using_seat)
	
	print("exit")
