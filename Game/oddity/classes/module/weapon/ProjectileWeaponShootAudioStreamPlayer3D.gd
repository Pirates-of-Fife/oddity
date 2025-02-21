extends AudioStreamPlayer3D

class_name ProjectileWeaponShootAudioStreamPlayer3D

@export
var sound : AudioStream

func _ready() -> void:
	stream = sound
	finished.connect(_on_audio_complete)
	play()
	
func _on_audio_complete() -> void:
	queue_free()
