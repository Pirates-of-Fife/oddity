extends Node3D

class_name SpawnShipUi

@export
var landing_pad : LandingPad

@export
var ship_scene : PackedScene

@export
var percentage_of_value : float = 0.4

var loadout_tools : LoadoutGenerator = LoadoutGenerator.new()

func _ready() -> void:
	update_price_information()


func _on_claim_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	var f : FileAccess = FileAccess.open(Globals.STARSHIP_SAVED_LOADOUT, FileAccess.READ)
	if f == null:
		$Decline.play()
		return

	var loadout : StarshipLoadout = load(Globals.STARSHIP_SAVED_LOADOUT)

	if loadout == null:
		$Decline.play()
		return

	if landing_pad.starship != null:
		$Decline.play()
		return

	if player.credits < loadout.value * percentage_of_value:
		$Decline.play()
		return

	player.remove_credits(loadout.value * percentage_of_value)

	var starship : Starship = ship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true
	
	get_tree().get_first_node_in_group("World").player_ship = starship
	
	get_tree().get_first_node_in_group("StarSystem").add_child(starship)

	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation

	loadout_tools.load_loadout(starship, loadout)
	$Spawn.play()
	
	ResourceSaver.save(loadout, Globals.PLAYER_SHIP_SAVE)

	
	update_price_information()


func _on_request_new_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landing_pad.starship != null:
		$Decline.play()
		return

	var starship : Starship = ship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true
	get_tree().get_first_node_in_group("StarSystem").add_child(starship)
	get_tree().get_first_node_in_group("World").player_ship = starship

	
	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation
	
	var default_loadout : StarshipLoadout = preload("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/resources/RABS_Kestrel_MK1_Default_Loadout.tres")
	
	ResourceSaver.save(default_loadout, Globals.PLAYER_SHIP_SAVE)
	
	$Spawn.play()
	
	update_price_information()

func update_price_information() -> void:
	var f : FileAccess = FileAccess.open(Globals.STARSHIP_SAVED_LOADOUT, FileAccess.READ)
	if f == null:
		return

	var loadout : StarshipLoadout = load(Globals.STARSHIP_SAVED_LOADOUT)

	if loadout == null:
		return

	var c : CreditHud = CreditHud.new()
	$Price.text = c.convert_to_human_readable(loadout.value * percentage_of_value)
	$Spawn.play()


func _on_request_new_ship_2_interacted(player: Player, control_entity: ControlEntity) -> void:
	update_price_information()
