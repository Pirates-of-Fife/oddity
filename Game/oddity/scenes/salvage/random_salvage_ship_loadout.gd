extends Node3D

@export
var ship : Starship

@export
var possible_loadouts : Array = Array()

var loadout_generator : LoadoutGenerator = LoadoutGenerator.new()

func _ready() -> void:
	var loadout : StarshipLoadout = possible_loadouts.pick_random()
	loadout_generator.load_loadout(ship, loadout, false)
	ship.ship_identification = ship.generate_ship_id()

	
