extends StaticGameEntity

class_name InsuranceTerminal

@export_category("Insurance")

@export
var insurance_ui : InsuranceUi

@export
var landing_pad : LandingPad

var landed_ship : Starship

@export
var station_pad : StationPad

@export_category("Power")

@export
var terminal_power_on_animation : TradeTerminalPowerOnAnimation

@export
var power_button : TradePowerOnButton

var is_on : bool = false

var ui_scene : String = "res://classes/insurance-terminal/InsuranceTerminalUI.tscn"

@onready
var loadout_tools : LoadoutGenerator = LoadoutGenerator.new()

func _ready() -> void:
	landing_pad.starship_landed.connect(_on_ship_landed)
	landing_pad.starship_took_off.connect(_on_ship_took_off)	

	power_button.power_switch_signal.connect(_on_power_switch)
	terminal_power_on_animation.powered_on.connect(_on_power_animation_finished)

func claim_ship(loadout : StarshipLoadout) -> void:
	var ship : Starship = spawn_ship(loadout)
	ship.ship_identification = ship.generate_ship_id()
	
func retrieve_ship(loadout : StarshipLoadout) -> void:
	spawn_ship(loadout)

func spawn_ship(loadout : StarshipLoadout) -> Starship:
	var starship_scene : PackedScene 
	
	match loadout.ship_type:
		Starship.ShipType.CORKSCREW:
			starship_scene = load("res://scenes/vehicles/starships/rabauke-shipworks/corkscrew/RABS_Corkscrew.tscn")
		Starship.ShipType.KESTREL:
			starship_scene = load("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/RABS_KestrelMk1.tscn")

	var starship : Starship = starship_scene.instantiate()
	starship.current_state = Starship.State.POWER_OFF
	starship.landing_gear_on = true
	
	get_tree().get_first_node_in_group("StarSystem").add_child(starship)

	starship.global_position = landing_pad.starship_spawn_marker.global_position
	starship.global_rotation = landing_pad.starship_spawn_marker.global_rotation

	loadout_tools.load_loadout(starship, loadout)
	
	return starship

func store_ship() -> void:
	if landed_ship != null:
		landed_ship.queue_free()

func _on_power_switch() -> void:
	if !is_on:
		terminal_power_on_animation.start_animation(station_pad.station.station_name)
		
		insurance_ui = load(ui_scene).instantiate()
		insurance_ui.ready.connect(_on_ui_load)
		insurance_ui.ship_claimed.connect(claim_ship)
		insurance_ui.ship_stored.connect(store_ship)
		insurance_ui.ship_retrieved.connect(retrieve_ship)
		insurance_ui.hide()
		add_child(insurance_ui)
		insurance_ui.rotation.y = deg_to_rad(-90)
	else:
		insurance_ui.hide()
		is_on = false
		insurance_ui.queue_free()

func _on_ui_load() -> void:
	insurance_ui.landed_ship = landed_ship
	insurance_ui.insurance_percentage = 0.15
	insurance_ui.price_markup = station_pad.station.buy_markup

func _on_power_animation_finished() -> void:
	insurance_ui.show()
	is_on = true

func _on_ship_landed(starship : Starship) -> void:
	landed_ship = starship
	
	if insurance_ui != null:
		insurance_ui.landed_ship = starship

func _on_ship_took_off(starship : Starship) -> void:
	landed_ship = null
	
	if insurance_ui != null:
		insurance_ui.landed_ship = null
