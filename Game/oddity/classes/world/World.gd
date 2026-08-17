extends Node3D

class_name World

@export
var caretaker : Caretaker

@onready
var abyss_scene : PackedScene = preload("res://classes/abyss/abyss/Abyss.tscn")

@onready
var abyssal_tunnel_scene : PackedScene = preload("res://classes/abyss/abyssal-tunnel/AbyssalTunnel.tscn")

var index : int = 0

@export
var star_systems : Array[StarSystemResource]

var in_range_systems : Array[StarSystemResource]

var abyss_entered : bool = false
var new_system_loaded : bool = false

@export
var player : Player

@export
var player_control_entity : Creature

@export
var spawn_station : SpaceStationLoadingZone

@export
var is_main_menu_world : bool = false

@export
var music_player : MusicPlayer

func _ready() -> void:
	add_to_group("World")

	if is_main_menu_world:
		return
	
	load_save()

func cycle_system() -> StarSystemResource:
	in_range_systems = get_star_systems_in_range()
	
	var size : int = in_range_systems.size()

	if size == 0:
		return get_current_star_sytem_resource()

	var system : StarSystemResource = in_range_systems[index]
	
	index += 1

	if index == size:
		index = 0

	return system

func get_current_star_sytem_resource() -> StarSystemResource:
	var star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	
	if star_system.system_name == "The Abyss":
		return star_systems[0]
	
	for system : StarSystemResource in star_systems:
		if system.name == star_system.system_name:
			return system
	
	return star_systems[0]

func get_star_system_resource(system_name : String) -> StarSystemResource:
	for system : StarSystemResource in star_systems:
		if system.name == system_name:
			return system
			
	return star_systems[0]

func get_star_systems_in_range() -> Array[StarSystemResource]:
	var systems_in_range : Array[StarSystemResource]
	var current : StarSystemResource = get_current_star_sytem_resource()
	
	if player == null:
		return systems_in_range
	
	if !(player.control_entity is Starship):
		return systems_in_range
	
	for system : StarSystemResource in star_systems:
		var distance : float = calculate_star_system_distance(current, system)
		
		if (distance <= player.control_entity.jump_range and distance > 0):
			systems_in_range.append(system)
	
	return systems_in_range
	
func calculate_star_system_distance(current : StarSystemResource, target : StarSystemResource) -> float:
	return current.position.distance_to(target.position)

func enter_abyss(destination_star_system : PackedScene, starship : Starship, portal_global_rotation : Vector3) -> void:
	if abyss_entered:
		return

	abyss_entered = true
	
	music_player.stop_music()
	
	for node : Node in get_tree().get_nodes_in_group("Starship"):
		if node != player.control_entity:
			node.queue_free()

	var old_star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	starship.reparent.call_deferred(self)
	old_star_system.queue_free()

	var new_star_system : StarSystem = destination_star_system.instantiate()
	var spawn_location : Vector3 = new_star_system.player_spawn_position
	new_star_system.queue_free()

	starship.is_in_abyss = true

	var abyss : Abyss = abyss_scene.instantiate()
	add_child.call_deferred(abyss)

	starship.reparent.call_deferred(abyss)

	starship.current_star_system = abyss
	starship.update_abyssal_mfd()

	starship.global_position = spawn_location

	var abyssal_tunnel : AbyssalTunnel = abyssal_tunnel_scene.instantiate()
	add_child(abyssal_tunnel)

	abyssal_tunnel.destination_star_system = destination_star_system
	abyssal_tunnel.global_position = spawn_location
	abyssal_tunnel.global_rotation = portal_global_rotation + Vector3(deg_to_rad(180), 0, 0)

func load_new_system(destination_star_system : PackedScene, starship : Starship) -> void:
	if new_system_loaded:
		return

	new_system_loaded = true

	var new_star_system : StarSystem = destination_star_system.instantiate()
	add_child(new_star_system)

	starship.reparent.call_deferred(new_star_system)
	
	if new_star_system.spawn_station != null:
		spawn_station = new_star_system.spawn_station
		player.respawn_star_system = destination_star_system
		
	var abyss : Abyss = get_tree().get_first_node_in_group("Abyss")
	abyss.queue_free()
	
	spawn_entities_in_system(new_star_system.name)
	
func load_star_system(star_system_resource : StarSystemResource) -> void:
	player_control_entity.reparent(self)
	
	var old_star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	
	if old_star_system != null:
		old_star_system.queue_free()
	
	var system_scene : PackedScene = load(star_system_resource.scene_file)
	
	var star_system : StarSystem = system_scene.instantiate()
	
	add_child(star_system)
	
	if star_system.spawn_station == null:
		player.respawn_star_system = load(star_systems[0].scene_file)
	else:
		spawn_station = star_system.spawn_station
		player.respawn_star_system = load(star_system_resource.scene_file)

	
	player_control_entity.reparent(star_system)
	
	star_system.name = star_system_resource.name
	
	index = 0
	
func unload_tunnel(abyssal_tunnel : AbyssalTunnel) -> void:
	abyssal_tunnel.starship.is_in_abyss = false

	abyssal_tunnel.starship.current_star_system = get_tree().get_first_node_in_group("StarSystem")

	abyssal_tunnel.starship.update_ui()
	abyssal_tunnel.starship.update_abyssal_mfd()
	abyssal_tunnel.starship.abyssal_mfd.set_gateway_closed()

	abyss_entered = false
	new_system_loaded = false


	abyssal_tunnel.queue_free()

func load_save() -> void:
	var save_file : SaveFile = caretaker.get_save_file()
	
	load_star_system(save_file.player_position.star_system)
	
	spawn_station = get_tree().get_first_node_in_group("StarSystem").spawn_station
	
	var ships_in_system : Array[Starship] = spawn_active_ships(save_file.active_ships, save_file.player_position.star_system.name)
	
	spawn_saved_game_entities(save_file.game_entities, save_file.player_position.star_system.name)
	
	spawn_player_character(save_file.player_position,save_file.inventory, save_file.credits, ships_in_system)

func spawn_entities_in_system(star_system : String) -> void:
	var save_file : SaveFile = caretaker.get_save_file()
	var ships_in_system : Array[Starship] = spawn_active_ships(save_file.active_ships, save_file.player_position.star_system.name)
	spawn_saved_game_entities(save_file.game_entities, save_file.player_position.star_system.name)
	
	print("Spawn")
	

func spawn_player_character(player_position_save : PlayerPositionSave, player_inventory : PlayerInventoryResource, credits : int, ships_in_system : Array[Starship]) -> void:
	player.inventory = player_inventory
	player.credits = credits
	player.hud.current_credits = player.credits
	player.hud.displayed_credits = player.credits
	
	if player_position_save.respawn_at_station:
		player_control_entity.global_position = spawn_station.player_spawn_marker.global_position
		player_control_entity.global_rotation = spawn_station.player_spawn_marker.global_rotation
	elif player_position_save.used_a_bed:
		var ship : Starship
		
		for s : Starship in ships_in_system:
			if s.ship_identification == player_position_save.starship_slept_with:
				ship = s
				
		player_control_entity.global_position = ship.get_bed(player_position_save.bed_index).player_spawn_position
		player_control_entity.global_rotation = ship.get_bed(player_position_save.bed_index).player_spawn_position_marker.global_rotation
	else:
		player_control_entity.global_position = player_position_save.position.toVector3()
		player_control_entity.global_rotation = player_position_save.rotation.toVector3()

func spawn_active_ships(active_ships : Array[StarshipSave], star_system : String) -> Array[Starship]:
	var ships_in_system : Array[Starship]

	for ship_save : StarshipSave in active_ships:
		if ship_save.star_system.name == star_system:
			ships_in_system.append(spawn_starship(ship_save))
	
	return ships_in_system

func spawn_starship(ship_save : StarshipSave) -> Starship:
	var scene : PackedScene = load(ship_save.game_entity_scene)
	var ship : Starship = scene.instantiate()

	ship.default_loadout = ship_save.loadout
	ship.apply_loadout_health = true
	if !ship_save.loadout.destroyed:
		ship.current_state = Starship.State.POWER_OFF
	
	get_tree().get_first_node_in_group("StarSystem").add_child(ship)
	
	ship.global_rotation = ship_save.rotation.toVector3()
	ship.global_position = ship_save.position.toVector3()
	
	return ship
	
func spawn_saved_game_entities(saved_game_entities : Array[GameEntitySave], star_system : String) -> void:
	for game_entity_save : GameEntitySave in saved_game_entities:
		if game_entity_save.star_system.name == star_system:
			var scene : PackedScene = load(game_entity_save.game_entity_scene)
			var game_entity : GameEntity = scene.instantiate()
			
			get_tree().get_first_node_in_group("StarSystem").add_child(game_entity)
			
			game_entity.value = game_entity_save.value
			game_entity.global_position = game_entity_save.position.toVector3()
			game_entity.global_rotation = game_entity_save.rotation.toVector3()
			
			print("spawned " + str(game_entity) + " " + str(game_entity.global_position))
	
func respawn_player() -> void:
	if abyss_entered:
		get_node("AbyssalTunnel").queue_free()
		get_node("AbyssalAmbiance").queue_free()
		abyss_entered = false

	var player_body : Creature = player.respawn_body.instantiate()
	player.reparent(self)
	add_child(player_body)
	player.possess(player_body)

	var star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	star_system.queue_free()

	var new_star_system : StarSystem = player.respawn_star_system.instantiate()
	add_child(new_star_system)
	player_body.reparent(new_star_system)

	spawn_station = new_star_system.spawn_station

	player_body.global_position = spawn_station.player_spawn_marker.global_position
	player_body.global_rotation = spawn_station.player_spawn_marker.global_rotation
	
	spawn_entities_in_system(new_star_system.name)

func _notification(what : int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:		
		get_tree().quit()

func bed_exit(bed_index : int, ship_id : String) -> void:
	caretaker.save(true, bed_index, ship_id)
		
	exit_to_main_menu()

func exit_to_main_menu() -> void:
	caretaker.save()
	
	await get_tree().create_timer(0.5).timeout
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	get_tree().get_first_node_in_group("Player").reparent(self)
		
	for node : Node in get_tree().get_nodes_in_group("Starship"):
		node.queue_free()
		
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_file("res://ui/main-menu/MainMenu.tscn")
