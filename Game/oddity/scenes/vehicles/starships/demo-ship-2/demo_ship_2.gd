extends Starship

class_name DemoShip2

func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	$DemoControlSeat.enter_seat(player, control_entity)


func _on_timer_timeout() -> void:
	respawn.rpc()
	print("RESAPWN")


func _on_heat_timer_timeout() -> void:	
	if heat == ambiant_heat:
		#$HeatTimer.start()
		return
		
	if heat - heat_decay < ambiant_heat:
		heat = ambiant_heat
		return
		
	if heat > max_heat:
		damage.rpc(15)
	
	heat -= heat_decay

	
	#$HeatTimer.start()


func _on_timer_2_timeout() -> void:
	$CanHeal.show()
	can_heal = true
