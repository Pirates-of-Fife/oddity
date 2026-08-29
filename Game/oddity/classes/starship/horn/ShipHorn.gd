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
var start_audio : AudioStreamPlayer3D

@export
var loop_audio : AudioStreamPlayer3D

@export
var end_audio : AudioStreamPlayer3D

var horn_ended : bool = true
var looping : bool = false

func _ready() -> void:
	start_audio.stream = horn_start
	loop_audio.stream = horn_loop
	end_audio.stream = horn_end
	
func start_horn() -> void:
	if !horn_ended:
		return
		
	horn_ended = false
	
	start_audio.play()
	start_loop()
	

func start_loop() -> void:
	
	if horn_ended:
		stop_loop()
	
	looping = true
	
	loop_audio.volume_db = -15
	loop_audio.play()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(loop_audio, "volume_db", 0, 1)
	
func stop_loop() -> void:	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(loop_audio, "volume_db", -20, 0.3)
	tween.finished.connect(_on_stop_loop)
	
func _on_stop_loop() -> void:
	loop_audio.stop()
	looping = false

func end_horn() -> void:
	horn_ended = true
	
	if looping:
		stop_loop()
		
	end_audio.play()
	
