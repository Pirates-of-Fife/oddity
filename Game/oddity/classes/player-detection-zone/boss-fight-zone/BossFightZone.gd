extends PlayerDetectionZone

class_name BossFightZone

@export_category("Boss")

@export
var boss_name : String

@export
var difficulty : Starship.BountyDifficulty

@export
var boss_loadout : StarshipLoadout

@export
var possible_loadouts : StarshipLoadoutSelection

var ship_scene : PackedScene = preload("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/RABS_KestrelMk1.tscn")
var ai_scene : PackedScene = preload("res://classes/mind/ai/Ai.tscn")
var despawn_ship_particles_scene : PackedScene = preload("res://classes/player-detection-zone/boss-fight-zone/DespawnShipParticles.tscn")
var marker_sprite : PackedScene = preload("res://classes/player-detection-zone/MarkerSprite.tscn")

@export_range(1, 3, 1, "or_greater", "suffix:Waves")
var waves : int

var current_wave : int = 1
var destroyed_ships_per_wave : int = 0
var boss_defeated : bool = false

@export_range(1, 3, 1, "suffix:Ships")
var ship_count_per_wave : int

@export_range(0, 30000, 100, "or_greater", "suffix:m")
var spawn_radius : float

var spawned_ships : Array = Array()


func _ready() -> void:
	super._ready()
	
	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)
	
	var marker : MarkerSprite = marker_sprite.instantiate()
	marker.text = "[BOSS SIGNAL] " + str(difficulty) + " THREAT - " + boss_name
	add_child(marker)
	
	use_distance_display = true
	distant_sprite = marker
	sprite_distance = 10_000
	sprite_max_distance = 200_000
	
	activate_distance = 10_000
	deactivate_distance = 100_000
	one_shot = true
	
func boss_finished() -> void:
	world.music_player.stop_music()

func start_wave() -> void:
	spawn_enemies(ship_count_per_wave)

func start_boss_wave() -> void:
	for i : int in ship_count_per_wave - 1:
		spawn_enemy_ship()
		
	spawn_enemy_ship(true)

func end_wave() -> void:
	for ship : Starship in spawned_ships:
		if ship.is_boss:
			continue
		
		var particles : DespawnShipParticles = despawn_ship_particles_scene.instantiate()
		world.add_child(particles)
		particles.ship = ship
		particles.start()
	
	await get_tree().create_timer(4).timeout
	
	spawned_ships.clear()
	destroyed_ships_per_wave = 0
	
	current_wave += 1
	
	if current_wave <= waves:
		start_wave()
	else:
		if !boss_defeated:
			start_boss_wave()
		else:
			boss_finished()
	
func spawn_enemies(count : int) -> void:
	for i : int in count:
		spawn_enemy_ship()

func spawn_enemy_ship(spawn_boss : bool = false) -> void:
	var ship : Starship = ship_scene.instantiate()
	
	if spawn_boss:
		ship.default_loadout = boss_loadout
		ship.state_changed_to_destroyed.connect(_on_boss_destroyed)
	else:
		ship.default_loadout = possible_loadouts.loadouts.pick_random()
	
	ship.state_changed_to_destroyed.connect(_on_enemy_ship_destroyed)
		
	ship.is_bounty_target = true
	ship.difficulty = difficulty
	ship.current_state = Starship.State.POWER_ON
	ship.landing_gear_on = false
	
	get_tree().get_first_node_in_group("StarSystem").add_child(ship)
	
	var ai : Ai = ai_scene.instantiate()
	ai.control_entity = ship
	get_tree().get_first_node_in_group("StarSystem").add_child(ai)

	var spawn_position : Vector3 = Vector3(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
	
	ship.global_position = global_position + spawn_position

	spawned_ships.append(ship)
		
	ship.ship_identification = ship.generate_ship_id()
	
func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	world.music_player.play_boss_music()
	
	start_wave()

func _on_boss_destroyed() -> void:
	boss_defeated = true

func _on_enemy_ship_destroyed() -> void:
	destroyed_ships_per_wave += 1
	
	if destroyed_ships_per_wave == ship_count_per_wave:
		end_wave()

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	for s : Starship in spawned_ships:
		s.queue_free()
	
	current_wave = 1
	destroyed_ships_per_wave = 0
	boss_defeated = false
	
	world.music_player.stop_music()
