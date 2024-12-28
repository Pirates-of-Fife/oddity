extends Node3D

class_name StarSystem

@export_category("System Bodies")

@export
var main_star : Node3D

@export_category("Player")

@export
var player_spawn_marker : Marker3D

func _ready() -> void:
	add_to_group("StarSystem")
