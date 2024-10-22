extends GameEntity

class_name ControlEntity

var player : Player = null

@export_category("Controller")

@export
var controller_reference : String

@export_category("Anchor")
@export
var anchor : Anchor

func set_active_anchor(new_anchor : Anchor) -> void:
	anchor.active = false
	anchor = new_anchor
	new_anchor.active = true
