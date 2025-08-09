extends Node3D

class_name World

@onready
var abyss_scene : PackedScene = preload("res://classes/abyss/abyss/Abyss.tscn")

@onready
var abyssal_tunnel_scene : PackedScene = preload("res://classes/abyss/abyssal-tunnel/AbyssalTunnel.tscn")

var index : int = 0

@export
var star_systems : Array

var abyss_entered : bool = false
var new_system_loaded : bool = false

@export
var player : Player

@export
var player_control_entity : Creature

@export
var player_ship : Starship

@export
var spawn_station : SpaceStationLoadingZone

var auto_save_timer : Timer = Timer.new()

@export
var is_main_menu_world : bool = false

func cycle_system() -> StarSystemResource:
	var size : int = star_systems.size()

	if size == 0:
		return

	var system : StarSystemResource = star_systems[index]

	index += 1

	if index == size:
		index = 0

	return system

func _ready() -> void:
	add_to_group("World")

	if is_main_menu_world:
		return

	auto_save_timer.timeout.connect(save_player_ship_state)
	auto_save_timer.one_shot = false
	auto_save_timer.autostart = true
	auto_save_timer.wait_time = 60
	add_child(auto_save_timer)

	spawn_station = get_tree().get_first_node_in_group("StarSystem").spawn_station

	spawn_player_ship()

	var f : FileAccess = FileAccess.open(Globals.PLAYER_MONEY, FileAccess.READ)
	if f == null:
		var res : PlayerMoneyResource = PlayerMoneyResource.new()
		res.credits = 10000

		ResourceSaver.save(res, Globals.PLAYER_MONEY)

	var credits_resource : PlayerMoneyResource = load(Globals.PLAYER_MONEY)

	player.credits = credits_resource.credits
	player.hud.current_credits = player.credits
	player.hud.displayed_credits = player.credits

func enter_abyss(destination_star_system : PackedScene, starship : Starship, portal_global_rotation : Vector3) -> void:
	if abyss_entered:
		return

	abyss_entered = true

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

	var abyss :Abyss = get_tree().get_first_node_in_group("Abyss")
	abyss.queue_free()


func unload_tunnel(abyssal_tunnel : AbyssalTunnel) -> void:
	abyssal_tunnel.starship.is_in_abyss = false

	abyssal_tunnel.starship.current_star_system = get_tree().get_first_node_in_group("StarSystem")

	abyssal_tunnel.starship.update_ui()
	abyssal_tunnel.starship.update_abyssal_mfd()
	abyssal_tunnel.starship.abyssal_mfd.set_gateway_closed()

	abyss_entered = false
	new_system_loaded = false


	abyssal_tunnel.queue_free()


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

	var default_loadout : StarshipLoadout = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/resources/RABS_Kestrel_MK1_Default_Loadout.tres")

	ResourceSaver.save(default_loadout, Globals.PLAYER_SHIP_SAVE)

func save_player_ship_state() -> void:
	if player_ship == null:
		return

	var loadout_generator : LoadoutGenerator = LoadoutGenerator.new()

	loadout_generator.save_loadout(player_ship, true, true, true)

func save_player_money_state() -> void:
	var f : FileAccess = FileAccess.open(Globals.PLAYER_MONEY, FileAccess.READ)
	if f == null:
		return

	var res : PlayerMoneyResource = PlayerMoneyResource.new()
	res.credits = player.credits

	ResourceSaver.save(res, Globals.PLAYER_MONEY)

func _notification(what : int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_player_ship_state()
		save_player_money_state()
		get_tree().quit()

func spawn_player_ship() -> void:
	var ship_scene : PackedScene = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/RABS_KestrelMk1.tscn")
	var ship : Starship = ship_scene.instantiate()
	var loadout : StarshipLoadout

	var f : FileAccess = FileAccess.open(Globals.PLAYER_SHIP_SAVE, FileAccess.READ)
	if f == null:
		loadout = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/resources/RABS_Kestrel_MK1_Default_Loadout.tres")
	else:
		loadout = load(Globals.PLAYER_SHIP_SAVE)

	ship.default_loadout = loadout
	ship.apply_loadout_health = true

	ship.current_state = Starship.State.POWER_OFF
	ship.landing_gear_on = true

	var star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	star_system.add_child(ship)

	ship.global_position = spawn_station.ship_spawn_marker.global_position
	ship.global_rotation = spawn_station.ship_spawn_marker.global_rotation

	player_control_entity.global_position = spawn_station.player_spawn_marker.global_position
	player_control_entity.global_rotation = spawn_station.player_spawn_marker.global_rotation

	player.possess(player_control_entity)

	player_ship = ship


func exit_to_main_menu() -> void:
	save_player_ship_state()
	get_tree().change_scene_to_file("res://ui/main-menu/MainMenu.tscn")
