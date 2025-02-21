extends Node3D

class_name StarshipTargetMFD

@export
var ship : Starship

@export
var starship_target_mfd_2d : StarshipTargetMfd2d

func _ready() -> void:
	ship.focused_target.connect(focused)
	ship.unfocused_target.connect(unfocused)

func update(starship : Starship) -> void:
	if starship != null:
		starship_target_mfd_2d.update_target_info(starship)

func focused(starship : Starship) -> void:
	starship_target_mfd_2d.update_target_info(starship)

func unfocused(starship : Starship) -> void:
	starship_target_mfd_2d.unfocus()
