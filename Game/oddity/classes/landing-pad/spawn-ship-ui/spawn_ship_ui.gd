extends Node3D

class_name SpawnShipUi

@export
var landing_pad : LandingPad

@export
var ship_scene : PackedScene 


var loadout_tools : LoadoutGenerator = LoadoutGenerator.new()

func _on_claim_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landing_pad.starship != null:
		return
	
	if player.credits < 10000:
		return
	
	player.remove_credits(10000)
	
	var starship : Starship = ship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true

	var loadout : StarshipLoadout = load("user://saved_loadout.tres")
	
	if loadout != null:
		starship.default_loadout = loadout
	
	get_tree().get_first_node_in_group("StarSystem").add_child(starship)
	
	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation
	
	loadout_tools.load_loadout(starship, loadout)
	
func _on_request_new_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landing_pad.starship != null:
		return
	
	var starship : Starship = ship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true
	get_tree().get_first_node_in_group("StarSystem").add_child(starship)
	
	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation
	
	
