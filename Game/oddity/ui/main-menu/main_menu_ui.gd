extends Control

signal animation_started()

var started : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and started == false:
		$AnimationPlayer.play("start")
		started = false
		animation_started.emit()
