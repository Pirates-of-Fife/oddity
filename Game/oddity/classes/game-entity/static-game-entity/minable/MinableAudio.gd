extends AudioStreamPlayer3D

class_name MineableAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(done)
	pitch_scale = randf_range(0.7, 1.3)
	
func done() -> void:
	queue_free()
