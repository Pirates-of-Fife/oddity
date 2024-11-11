extends Node3D

@export
var starship : Starship

@onready
var health_bar : ProgressBar = $HealthVP/Control/ProgressBar
@onready
var enemy_health_bar : ProgressBar = $EnemyVP/Control/ProgressBar
@onready
var throttle_bar : ProgressBar = $ThrottleVP/Control/ProgressBar
@onready
var speed_bar : ProgressBar = $SpeepVP/Control/ProgressBar
@onready
var heat_bar : ProgressBar = $HeatVP/Control/ProgressBar

@export
var crosshair : Node3D


func _ready() -> void:
	health_bar.max_value = starship.max_health
	enemy_health_bar.max_value = starship.max_health
	throttle_bar.max_value = 1
	speed_bar.max_value = starship.ship_info.max_linear_velocity
	heat_bar.max_value = starship.max_heat

func _process(delta: float) -> void:
	health_bar.value = starship.health
	enemy_health_bar.value = starship.enemy_health
	throttle_bar.value = absf(starship.target_thrust_vector.z)
	speed_bar.value = abs(starship.local_linear_velocity.z)
	heat_bar.value = starship.heat
	crosshair.x_offset = starship.target_rotational_thrust_vector.y * 100
	crosshair.y_offset = -starship.target_rotational_thrust_vector.x * 100
