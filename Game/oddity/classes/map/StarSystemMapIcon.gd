@tool
extends Sprite2D

class_name StarSystemMapIcon

@export
var map : StarSystemMap

@export
var star_system_resource : StarSystemResource

func update_icon_position() -> void:
	position = map.convert_ly_to_px_coords(star_system_resource.position)
