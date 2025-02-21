extends AudioStreamPlayer

class_name AbyssalAmbiance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("start")
	print("PLAYERSTARTED")


func stop_playing() -> void:
	$AnimationPlayer.play("stop")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stop":
		queue_free()
