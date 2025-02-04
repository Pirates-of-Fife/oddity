extends AudioStreamPlayer3D

class_name RadioChatterPlayer

@export
var audio_streams : Array = Array()

var can_play : bool = false

func start_playing() -> void:
	if can_play:
		return
	
	can_play = true
	$Timer.start()

func stop_playing() -> void:
	can_play = false

func play_random_sample() -> void:
	stream = audio_streams.pick_random()
	play()

func _on_timer_timeout() -> void:
	if can_play:
		play_random_sample()


func _on_finished() -> void:
	$Timer.wait_time = randf_range(4, 12)
	$Timer.start()
	
