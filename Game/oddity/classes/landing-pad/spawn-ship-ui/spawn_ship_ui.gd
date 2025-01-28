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
	var f : FileAccess = FileAccess.open("user://saved_loadout.tres", FileAccess.READ)
	if f == null:
		return

	var loadout : StarshipLoadout = load("user://saved_loadout.tres")

	if loadout == null:
		return

	if landing_pad.starship != null:
		return

	if player.credits < loadout.value * percentage_of_value:
		return

	player.remove_credits(loadout.value * percentage_of_value)

	var starship : Starship = ship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true

	get_tree().get_first_node_in_group("StarSystem").add_child(starship)

	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation

	loadout_tools.load_loadout(starship, loadout)

	update_price_information()


func _on_request_new_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landing_pad.starship != null:
		return

	var starship : Starship = ship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true
	get_tree().get_first_node_in_group("StarSystem").add_child(starship)

	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation

	update_price_information()

func update_price_information() -> void:
	var f : FileAccess = FileAccess.open("user://saved_loadout.tres", FileAccess.READ)
	if f == null:
		return

	var loadout : StarshipLoadout = load("user://saved_loadout.tres")

	if loadout == null:
		return

	var c : CreditHud = CreditHud.new()
	$Price.text = c.convert_to_human_readable(loadout.value * percentage_of_value)

func _on_request_new_ship_2_interacted(player: Player, control_entity: ControlEntity) -> void:
	update_price_information()
