extends Node3D

class_name RabaukePowerScreen

@export
var animation_player : AnimationPlayer

func power_on() -> void:
	animation_player.play("power_on")

func power_off() -> void:
	animation_player.play("power_off")

func set_state_power_on() -> void:
	animation_player.play("power_on")
	animation_player.seek(5)
	
func set_state_power_off() -> void:
	animation_player.play("power_off")
	animation_player.seek(5)
