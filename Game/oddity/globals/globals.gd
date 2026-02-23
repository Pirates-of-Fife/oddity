extends Node

@export
var creature_controller_sensitivity : float = 0.001

@export
var starship_controller_sensitity : float = 0.1

@export
var music_volume : float = 1 : 
	get:
		return lerpf(-32, 0, music_volume)
	set(value):
		music_volume = maxf(0, minf(1, value))

@export
var music_disabled : float = false

const SETTINGS_FILE: String = "user://settings.cfg"

const STARSHIP_SAVED_LOADOUT : String = "user://saved_loadout.tres"
const PLAYER_SHIP_SAVE : String = "user://player_saved_ship.tres"
const PLAYER_MONEY : String = "user://player_money.tres"
const PLAYER_INVENTORY : String = "user://player_inventory.tres"
const PLAYER_POSITION_SAVE : String = "user://player-position.tres"

func _ready() -> void:
	load_settings()

func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new()

	config.set_value("mouse", "creature_controller_sensitivity", creature_controller_sensitivity)
	config.set_value("mouse", "starship_controller_sensitity", starship_controller_sensitity)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "music_disabled", music_disabled)

	config.save(SETTINGS_FILE)

func load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()

	config.load(SETTINGS_FILE)

	creature_controller_sensitivity = config.get_value("mouse", "creature_controller_sensitivity", 0.001)
	starship_controller_sensitity = config.get_value("mouse", "starship_controller_sensitity", 0.1)
	music_volume = config.get_value("audio", "music_volume", 1)
	music_disabled = config.get_value("audio", "music_disabled", false)

	
