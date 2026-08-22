extends PlayerDetectionZone

class_name ShipZone

var loadout : StarshipLoadout

var spawned : bool = false

func _ready() -> void:
	activate_distance = 5000
	deactivate_distance = 6500
	update_time = 0.5
	one_shot = false

	use_distance_display = true
	sprite_distance = 5000
	sprite_max_distance = 1_000_000
	distant_sprite = _create_distance_display()

	add_to_group("Starship")

	activate.connect(on_activate)

	super._ready()
	
func _create_distance_display() -> MarkerSprite:
	var sprite_scene : PackedScene = load("res://classes/player-detection-zone/MarkerSprite.tscn")
	var sprite : MarkerSprite = sprite_scene.instantiate()
	
	sprite.text = loadout.ship_name + " - " + loadout.ship_identification
	if loadout.destroyed:
		sprite.text += " - Wreckage"
	
	add_child(sprite)
	
	return sprite

func on_activate(player : Player, control_entity : ControlEntity) -> void:
	if spawned:
		return

	var scene : PackedScene = load(Starship.get_ship_scene(loadout.ship_type))
	var ship : Starship = scene.instantiate()

	ship.default_loadout = loadout
	ship.apply_loadout_health = true
	ship.is_player_ship = true
	
	if !loadout.destroyed:
		ship.current_state = Starship.State.POWER_OFF
	
	get_tree().get_first_node_in_group("StarSystem").add_child(ship)
	
	ship.global_rotation = global_rotation
	ship.global_position = global_position
	
	spawned = true
	
	queue_free()