extends Node3D

@export
var ship : Starship



func _on_timer_timeout() -> void:
	ship.shoot_primary()
	ship.shoot_secondary()
