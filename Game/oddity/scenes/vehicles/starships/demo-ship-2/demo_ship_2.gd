extends Starship

class_name DemoShip2

func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	$DemoControlSeat.enter_seat(player, control_entity)

func _process(delta: float) -> void:
	if health <= 500:
		$Warning.show()
	else:
		$Warning.hide()
		
	if heat >= max_heat:
		$Overheat.show()
	else:
		$Overheat.hide()
		
	if boosting:
		$Boost.show()
	else:
		$Boost.hide()
		
	if $ShapeCast3D.is_colliding() and local_linear_velocity.length() > 100:
		$CollisionAlert.show()
	else:
		$CollisionAlert.hide()
		

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


func _on_body_entered(body: Node) -> void:
	if local_linear_velocity.length() > 10 and body is not Projectile:
		if body is Starship:
			damage.rpc((local_linear_velocity.length() + body.local_linear_velocity.length()) ** 2)
			return
		if body is StaticGameEntity:
			if body.ignore_collision_damage == true:
				return
		
		damage.rpc(local_linear_velocity.length() ** 1.7)
