extends PlayerDetectionZone

class_name BountyHuntingZone

@export_category("Bounty Hunting")

@export
var difficulty : Starship.BountyDifficulty

@export
var possible_loadouts : Array = Array()

@export
var ship_scene : PackedScene = preload("res://scenes/vehicles/starships/rabauke-shipworks/kestrel-mk-1/RABS_KestrelMk1.tscn")

@export
var ai_scene : PackedScene = preload("res://classes/mind/ai/Ai.tscn")

@export_range(0, 3, 1)
var ship_count : int

@export_range(0, 30000, 100, "or_greater")
var spawn_radius : float

var spawned_ships : Array = Array()

func _ready() -> void:
	_bounty_hunting_zone_ready()

func _bounty_hunting_zone_ready() -> void:
	_player_detection_zone_ready()

	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)

func spawn_ships() -> void:
	for i : int in ship_count:
		spawn_bounty_target()

func spawn_bounty_target() -> void:
	var ship : Starship = ship_scene.instantiate()
	ship.default_loadout = possible_loadouts.pick_random()
	ship.is_bounty_target = true
	ship.difficulty = difficulty
	ship.current_state = Starship.State.POWER_ON
	ship.landing_gear_on = false
	add_child.call_deferred(ship)

	var ai : Ai = ai_scene.instantiate()
	ai.control_entity = ship
	add_child.call_deferred(ai)

	var spawn_position : Vector3 = Vector3(randf_range(0, spawn_radius), randf_range(0, spawn_radius), randf_range(0, spawn_radius))

	ship.position = spawn_position

	spawned_ships.append(ship)

func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	spawn_ships()

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	for s : Starship in spawned_ships:
		if s.current_state == Starship.State.DESTROYED:
			s.queue_free()
