extends BountyHuntingZone

class_name BossFightZone

@export_category("Boss Fight")

@export
var boss_loadout : StarshipLoadout

@export
var is_boss_spawned : bool = false

@export
var max_active_ships : int = 3

@export
var music_player : AudioStreamPlayer3D

var boss_ship : Starship = null
var active_wave_ships : Array = Array()
var total_waves_spawned : int = 0

func _ready() -> void:
	_boss_fight_zone_ready()

func _boss_fight_zone_ready() -> void:
	_bounty_hunting_zone_ready()

func spawn_ships() -> void:
	# First spawn the boss
	if !is_boss_spawned:
		spawn_boss()
	
	# Then spawn initial wave
	spawn_wave()

func spawn_boss() -> void:
	var ship : Starship = ship_scene.instantiate()
	ship.default_loadout = boss_loadout if boss_loadout != null else possible_loadouts.pick_random()
	ship.is_bounty_target = true
	ship.difficulty = difficulty
	ship.current_state = Starship.State.POWER_ON
	ship.landing_gear_on = false
	get_tree().get_first_node_in_group("StarSystem").add_child(ship)

	var ai : Ai = ai_scene.instantiate()
	ai.control_entity = ship
	get_tree().get_first_node_in_group("StarSystem").add_child(ai)

	var spawn_position : Vector3 = Vector3(randf_range(0, spawn_radius), randf_range(0, spawn_radius), randf_range(0, spawn_radius))
	
	ship.global_position = global_position + spawn_position
	ship.ship_identification = ship.generate_ship_id()
	
	boss_ship = ship
	spawned_ships.append(ship)
	is_boss_spawned = true
	
	# Connect to boss death signal
	ship.state_changed_to_destroyed.connect(_on_boss_destroyed)
	
	# Start music if available
	if music_player != null and !music_player.playing:
		music_player.play()

func spawn_wave() -> void:
	# Check how many ships are currently active
	var active_count : int = 0
	for s : Starship in active_wave_ships:
		if is_instance_valid(s) and s.current_state != Starship.State.DESTROYED:
			active_count += 1
	
	# Spawn ships up to max_active_ships
	var ships_to_spawn : int = min(max_active_ships - active_count, ship_count)
	
	for i : int in ships_to_spawn:
		spawn_bounty_target()
		total_waves_spawned += 1

func spawn_bounty_target() -> void:
	var ship : Starship = ship_scene.instantiate()
	ship.default_loadout = possible_loadouts.pick_random()
	ship.is_bounty_target = true
	ship.difficulty = difficulty
	ship.current_state = Starship.State.POWER_ON
	ship.landing_gear_on = false
	get_tree().get_first_node_in_group("StarSystem").add_child(ship)

	var ai : Ai = ai_scene.instantiate()
	ai.control_entity = ship
	get_tree().get_first_node_in_group("StarSystem").add_child(ai)

	var spawn_position : Vector3 = Vector3(randf_range(0, spawn_radius), randf_range(0, spawn_radius), randf_range(0, spawn_radius))
	
	ship.global_position = global_position + spawn_position
	ship.ship_identification = ship.generate_ship_id()
	
	active_wave_ships.append(ship)
	spawned_ships.append(ship)
	
	# Connect to ship destroyed signal to spawn more waves
	ship.state_changed_to_destroyed.connect(_on_wave_ship_destroyed.bind(ship))

func _on_wave_ship_destroyed(ship : Starship) -> void:
	# Remove from active ships
	active_wave_ships.erase(ship)
	
	# If boss is still alive, spawn more ships
	if is_instance_valid(boss_ship) and boss_ship.current_state != Starship.State.DESTROYED:
		# Wait a moment before spawning next wave
		await get_tree().create_timer(2.0).timeout
		spawn_wave()

func _on_boss_destroyed() -> void:
	# Stop spawning new waves
	is_boss_spawned = false
	
	# Stop music if playing
	if music_player != null and music_player.playing:
		music_player.stop()

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	super._on_deactivate(player, control_entity)
	
	# Stop music when leaving zone
	if music_player != null and music_player.playing:
		music_player.stop()
