extends Node3D

@export
var starship : Starship

@export
var health_bar : ProgressBar

@export
var enemy_health_bar : ProgressBar

@export
var throttle_bar : ProgressBar

@export
var speed_bar : ProgressBar

@export
var crosshair : Node3D


func _ready() -> void:
	health_bar.max_value = starship.max_health
	enemy_health_bar.max_value = starship.max_health
	throttle_bar.max_value = 1
	speed_bar.max_value = starship.ship_info.max_linear_velocity

func _process(delta: float) -> void:
	health_bar.value = starship.health
	enemy_health_bar.value = starship.enemy_health
	throttle_bar.value = absf(starship.target_thrust_vector.z)
	speed_bar.value = abs(starship.local_linear_velocity.z)
	crosshair.x_offset = starship.target_rotational_thrust_vector.y * 100
	crosshair.y_offset = -starship.target_rotational_thrust_vector.x * 100
