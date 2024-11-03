extends Starship

class_name DemoShip2

func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	$DemoControlSeat.enter_seat(player, control_entity)


func _on_timer_timeout() -> void:
	respawn.rpc()
	print("RESAPWN")
