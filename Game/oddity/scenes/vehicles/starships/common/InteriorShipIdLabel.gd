extends Label3D

@export
var starship : Starship

func _ready() -> void:
	starship.ready.connect(_set_text)

func _set_text() -> void:
	text = starship.ship_identification  