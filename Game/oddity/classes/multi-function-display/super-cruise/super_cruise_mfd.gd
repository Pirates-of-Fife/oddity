extends Control

class_name SuperCruiseMFD

var throttle : float
var velocity : float
var velocity_c :float
var max_velocity : float

@export
var throttle_progress_bar : ProgressBar

@export
var velocity_progress_bar : ProgressBar

@export
var velocity_label : RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_progress_bar.max_value = max_velocity

	velocity_progress_bar.value = absf(velocity)

	velocity_label.text = str(("%.2f" % velocity_c)) + " C"

	throttle_progress_bar.value = absf(throttle)
