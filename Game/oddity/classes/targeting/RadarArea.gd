extends Area3D

class_name RadarArea

signal entity_entered_radar_area(entity : GameEntity)
signal entity_exited_radar_area(entity : GameEntity)

@export
var starship : Starship

@export
var entities : Array = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_radar_area_ready()

func _radar_area_ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body : Node3D) -> void:
	if body is GameEntity:
		if body == starship:
			return

		if body.freeze == false:
			entities.append(body)
			entity_entered_radar_area.emit(body)

func _on_body_exited(body : Node3D) -> void:
	if body is GameEntity:
		if body == starship:
			return

		if body in entities:
			entities.erase(body)
			entity_exited_radar_area.emit(body)
