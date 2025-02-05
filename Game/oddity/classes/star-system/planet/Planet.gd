extends StaticGameEntity

class_name Planet

@export
var planet_name : StringName

@export
var is_rocky_body : bool = true

func _ready() -> void:
	if is_rocky_body:
		collision_layer = 2097409
		collision_mask = 2097409
