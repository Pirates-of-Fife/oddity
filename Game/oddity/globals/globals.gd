extends Node

@export
var creature_controller_sensitivity : float = 0.001

@export
var starship_controller_sensitity : float = 0.1

const SETTINGS_FILE: String = "user://settings.cfg"

func _ready() -> void:
	load_settings()

func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new()

	config.set_value("mouse", "creature_controller_sensitivity", creature_controller_sensitivity)
	config.set_value("mouse", "starship_controller_sensitity", starship_controller_sensitity)

	config.save(SETTINGS_FILE)

func load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()

	config.load(SETTINGS_FILE)

	creature_controller_sensitivity = config.get_value("mouse", "creature_controller_sensitivity", 0.001)
	starship_controller_sensitity = config.get_value("mouse", "starship_controller_sensitity", 0.1)
