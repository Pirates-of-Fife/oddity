extends Node3D

class_name PlayerDetectionZone

signal activate(player : Player, control_entity : ControlEntity)
signal deactivate(player : Player, control_entity : ControlEntity)

@onready
var player : Player = get_tree().get_first_node_in_group("Player")

@export_category("Player Detection")

@export_range(0, 100000, 1000, "or_greater")
var activate_distance : float

@export_range(0, 100000, 1000, "or_greater")
var deactivate_distance : float

@export_range(0, 1, 0.1, "or_greater")
var update_time : float = 0.3

@export
var one_shot : bool = false

var has_been_activated : bool = false

var active : bool = false

func _ready() -> void:
	_player_detection_zone_ready()

func _player_detection_zone_ready() -> void:
	var timer : Timer = Timer.new()
	timer.wait_time = update_time
	timer.one_shot = false
	timer.autostart = true
	timer.process_callback = Timer.TIMER_PROCESS_IDLE
	timer.timeout.connect(update)

func update() -> void:
	var distance : float = get_player_distance()

	if !active:
		if one_shot:
			if has_been_activated:
				return

		if distance < activate_distance:
			activate.emit(player, player.control_entity)
			active = true
			has_been_activated = true
	elif active:
		if distance > deactivate_distance:
			deactivate.emit(player, player.control_entity)
			active = false

func get_player_distance() -> float:
	return (global_position - player.control_entity.global_position).length()
