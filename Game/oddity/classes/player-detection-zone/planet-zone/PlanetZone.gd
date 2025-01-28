extends PlayerDetectionZone

class_name PlanetZone

@export_category("Planet Zone")

@export
var planet_gravity : GravityWell


func _ready() -> void:
	_planet_zone_ready()

func _planet_zone_ready() -> void:
	_player_detection_zone_ready()

	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)
	
	activate_distance = planet_gravity.radius * 1.5

func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	if control_entity is Starship:
		if control_entity.travel_mode == StarshipTravelModes.TravelMode.SUPER_CRUISE:
			control_entity.exit_super_cruise(true)
			(player.current_controller as StarshipController).supercruise_exit_timer.start()
			
			if control_entity.current_super_cruise_speed > 500:
				control_entity.take_damage(control_entity.current_super_cruise_speed * 6)

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	pass
