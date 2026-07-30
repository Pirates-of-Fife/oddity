extends StaticGameEntity

var damage_in_last_second: float = 0
var damage_timer: Timer

var total_damage : float = 0

func _on_damage_timer_timeout() -> void:
	#print("DPS: " + str(damage_in_last_second / 2))
	damage_in_last_second = 0

func _ready() -> void:
	on_damage_taken.connect(on_damaged)
	
	# Create a timer if it doesn't exist
	damage_timer = get_node_or_null("DamageTimer")
	if damage_timer == null:
		damage_timer = Timer.new()
		damage_timer.name = "DamageTimer"
		damage_timer.wait_time = 2.0
		damage_timer.one_shot = false
		damage_timer.autostart = true
		add_child(damage_timer)
	
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	damage_timer.start()

func on_damaged(damage : float) -> void:
	#_ready()
	
	#print("Damage: " + str(damage))
	total_damage += damage
	
	#print("Total damage: " + str(total_damage))
	damage_in_last_second += damage
	
	if (total_damage) > 2000000:
		total_damage = 0
	
	#var random2 : int = randi_range(0, 100)
	
	#if random2 < 75:
	#	return
	
	#var player : Player = get_tree().get_first_node_in_group("Player")
	
	#var random : int = randi_range(-5000, 20000)
	
#	if random >= 0:
#		player.add_credits(random)
#	else:
#		player.remove_credits(random)
