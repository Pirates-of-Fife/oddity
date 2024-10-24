extends Starship

class_name DemoShip2

func _process(delta: float) -> void:
	move_ball()

func move_ball() -> void:
	$Anchor/SpaceBall.position.x = -target_rotational_thrust_vector.y
	$Anchor/SpaceBall.position.y = -target_rotational_thrust_vector.x


func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	$DemoControlSeat.
