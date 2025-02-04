extends AudioStreamPlayer

class_name BlueDanubePlayer

var current_position : float = 0

func resume_playing() -> void:
	$AnimationPlayer.play("Start")
	play(current_position)
	
	
func pause_playing() -> void:
	$AnimationPlayer.play("Stop")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Stop":
		stop()
		current_position = get_playback_position()
