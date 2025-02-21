extends Node3D

class_name StarSystem

@export
var system_name : StringName = "Star System"

@export_category("System Bodies")

@export
var main_star : Node3D

@export_category("Player")

@export
var player_spawn_marker : Marker3D

func _ready() -> void:
	add_to_group("StarSystem")
