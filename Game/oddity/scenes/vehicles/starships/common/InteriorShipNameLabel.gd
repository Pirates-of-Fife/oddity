extends Label3D

@export
var starship : Starship

func _ready() -> void:
	starship.ready.connect(_on_ready)
	starship.ship_name_changed.connect(_on_change)
	
func _on_ready() -> void:
	text = starship.ship_name
	
func _on_change(ship_name : String) -> void:
	text = ship_name
