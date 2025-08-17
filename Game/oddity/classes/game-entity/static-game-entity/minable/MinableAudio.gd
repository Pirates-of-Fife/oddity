extends AudioStreamPlayer3D

class_name MineableAudio

@export_range(0, 5, 0.1)
var base_pitch : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(done)
	pitch_scale = randf_range(base_pitch * 0.7, base_pitch * 1.3)
	
func done() -> void:
	queue_free()
