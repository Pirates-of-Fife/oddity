extends Node3D

class_name ShipHorn

@export_category("Sounds")

@export
var horn_start : AudioStream

@export
var horn_loop : AudioStream

@export
var horn_end : AudioStream

@export
var audio_player : AudioStreamPlayer3D


func start_horn() -> void:
	audio_player.stream = horn_start
	audio_player.play()
	
	audio_player.finished.connect(_on_horn_start_end)
	
func end_horn() -> void:
	audio_player.finished.connect(_on_horn_loop_end)

func _on_horn_start_end() -> void:
	audio_player.stream = horn_loop
	audio_player.play()
	
	audio_player.finished.disconnect(_on_horn_start_end)

func _on_horn_loop_end() -> void:
	audio_player.stream = horn_end
	audio_player.play()
