extends Interactable

class_name ControlSeat

@export_category("Control Entity")

@export
var target_control_entity : ControlEntity

@export
var control_seat_anchor : Anchor

var player_using_seat : Player
var entity_using_seat : ControlEntity
var entity_parent : Node3D

func interact(player : Player, control_entity : ControlEntity) -> void:
	enter_seat(player, control_entity)
	interacted.emit(player, control_entity)

func enter_seat(player : Player, control_entity : ControlEntity) -> void:
	entity_parent = control_entity.get_parent_node_3d()
	entity_using_seat = control_entity
	player_using_seat = player
	
	target_control_entity.set_active_anchor(control_seat_anchor)
	player_using_seat.possess(target_control_entity)
	entity_using_seat.reparent.call_deferred(self)
	entity_using_seat.freeze_static()
	
func exit_seat() -> void:
	entity_using_seat.unfreeze()
	entity_using_seat.reparent.call_deferred(entity_parent)
	player_using_seat.possess(entity_using_seat)
	
