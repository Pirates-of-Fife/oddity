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
	

func enter_abyss(destination_star_system : PackedScene, starship : Starship, portal_global_rotation : Vector3) -> void:
	if abyss_entered:
		return
	
	abyss_entered = true
	
	print("Abyss Entered")
	var old_star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	starship.reparent.call_deferred(self)
	old_star_system.queue_free()
	print("old system unloaded")

	print("new star system instanced")
	var new_star_system : StarSystem = destination_star_system.instantiate()
	var spawn_location : Vector3 = new_star_system.player_spawn_position
	new_star_system.queue_free()
	print("new star system unloaded")

	
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
	var player : Player = get_tree().get_first_node_in_group("Player")
	var player_body : Creature = player.respawn_body.instantiate()
	add_child(player_body)
	player.possess(player_body)
	
	var star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	star_system.queue_free()
	
	var new_star_system : StarSystem = player.respawn_star_system.instantiate()
	add_child(new_star_system)
	player_body.reparent(new_star_system)
	player_body.global_position = new_star_system.player_respawn_position
	

	
	
