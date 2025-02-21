extends AudioStreamPlayer3D

class_name ProjectileCollisionAudioStreamPlayer3D

@export
var sounds : Array = Array()

func _ready() -> void:
	stream = sounds.pick_random()
	finished.connect(_on_audio_complete)
	play()
	
func _on_audio_complete() -> void:
	queue_free()
