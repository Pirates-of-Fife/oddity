extends RadarArea

class_name RadarSurroundingArea

func _ready() -> void:
	_radar_surrounding_area_ready()

func _radar_surrounding_area_ready() -> void:
	_radar_area_ready()

	entity_entered_radar_area.connect(_on_enter)
	entity_exited_radar_area.connect(_on_exit)

func _on_enter(entity : GameEntity) -> void:
	pass

func _on_exit(entity : GameEntity) -> void:
	if entity == starship.focused_starship:
		starship.unfocus_target(entity)
