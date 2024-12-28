extends Node3D

class_name World

@onready
var abyss_scene : PackedScene = preload("res://classes/abyss/abyss/Abyss.tscn")

@onready
var abyssal_tunnel_scene : PackedScene = preload("res://classes/abyss/abyssal-tunnel/AbyssalTunnel.tscn")

func _ready() -> void:
	add_to_group("World")
	
func load_star_system(destination_star_system : PackedScene, starship : Starship, portal : AbyssalPortal) -> void:
	var old_star_system : StarSystem = get_tree().get_first_node_in_group("StarSystem")
	starship.reparent.call_deferred(self)
	old_star_system.queue_free.call_deferred()
	
	print("old system unloaded")
	
	var abyss : Abyss = abyss_scene.instantiate()
	add_child.call_deferred(abyss)
	
	starship.reparent.call_deferred(abyss)

	
	var abyssal_tunnel : AbyssalTunnel = abyssal_tunnel_scene.instantiate()
	add_child(abyssal_tunnel)
	
	abyssal_tunnel.global_position = portal.global_position
	abyssal_tunnel.global_rotation = portal.global_rotation + Vector3(0, deg_to_rad(180), 0)
	
	print(abyssal_tunnel.global_position)
	print(portal.global_position)
	
	
	#var new_star_system : StarSystem = destination_star_system.instantiate()
	#add_child(new_star_system)
	
	#print("new system loaded")
	
	#starship.reparent.call_deferred(new_star_system)
	
	
	
