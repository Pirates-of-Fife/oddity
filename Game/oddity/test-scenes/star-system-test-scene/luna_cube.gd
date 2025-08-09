extends StaticGameEntity

func _ready() -> void:
	on_damage_taken.connect(on_damaged)

func on_damaged(damage : float) -> void:
	var random2 : int = randi_range(0, 100)
	
	if random2 < 75:
		return
	
	var player : Player = get_tree().get_first_node_in_group("Player")
	
	var random : int = randi_range(-5000, 20000)
	
	if random >= 0:
		player.add_credits(random)
	else:
		player.remove_credits(random)
