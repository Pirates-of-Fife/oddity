@tool
extends PlayerDetectionZone

class_name PlanetLoadingZone

@export
var planet_name : StringName

@export
var planet_scene : PackedScene

@export
var planet_scale : PlanetSize

var loaded_planet : Planet

enum PlanetSize
{
	MOON,
	PLANET,
	BIG_PLANET,
	GAS_GIANT
}

@export_category("Tools")

@export
var active_editor : bool : 
	set(value):
		_on_activate(null, null)

@export
var deactive_editor : bool : 
	set(value):
		_on_deactivate(null, null)

func _ready() -> void:
	_planet_loading_zone_ready()

func _planet_loading_zone_ready() -> void:
	_player_detection_zone_ready()

	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)
	distant_sprite.text = planet_name
	
	use_distance_display = true
	
	match planet_scale:
		PlanetSize.MOON:
			activate_distance = 5000000
			deactivate_distance = 5500000
			sprite_distance = 160000
			sprite_max_distance = 1450000
		PlanetSize.PLANET:
			activate_distance = 10000000
			deactivate_distance = 11000000
			sprite_distance = 200000
		PlanetSize.BIG_PLANET:
			activate_distance = 20000000
			deactivate_distance = 25000000
			sprite_distance = 350000
		PlanetSize.GAS_GIANT:
			activate_distance = 35000000
			deactivate_distance = 38000000
			sprite_distance = 400000

func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	var planet : Planet = planet_scene.instantiate()
	add_child(planet)
	loaded_planet = planet
			

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	loaded_planet.queue_free()
