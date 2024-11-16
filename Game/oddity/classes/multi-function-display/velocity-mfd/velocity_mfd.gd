extends Control

class_name VelocityMFD

var throttle : float

var vertical_velocity_up : float
var vertical_velocity_down : float
var lateral_velocity_left : float
var lateral_velocity_right : float
var forwards_velocity : float
var velocity : float
var max_velocity : float
var current_max_velocity : float

@export
var vertical_velocity_up_progress_bar : ProgressBar

@export
var vertical_velocity_down_progress_bar : ProgressBar

@export
var lateral_velocity_left_progress_bar : ProgressBar

@export
var lateral_velocity_right_progress_bar : ProgressBar

@export
var forwards_backwards_velocity_progress_bar : ProgressBar

@export
var throttle_progress_bar : ProgressBar

@export
var max_velocity_progress_bar : ProgressBar

@export
var velocity_label : RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	max_velocity_progress_bar.max_value = max_velocity
	vertical_velocity_down_progress_bar.max_value = current_max_velocity
	vertical_velocity_up_progress_bar.max_value = current_max_velocity
	lateral_velocity_left_progress_bar.max_value = current_max_velocity
	lateral_velocity_right_progress_bar.max_value = current_max_velocity
	forwards_backwards_velocity_progress_bar.max_value = current_max_velocity
	
	vertical_velocity_down_progress_bar.value = vertical_velocity_down
	vertical_velocity_up_progress_bar.value = vertical_velocity_up
	lateral_velocity_left_progress_bar.value = lateral_velocity_left
	lateral_velocity_right_progress_bar.value = lateral_velocity_right
	
	forwards_backwards_velocity_progress_bar.value = absf(forwards_velocity)
	
	if forwards_velocity > 0:
		forwards_backwards_velocity_progress_bar.fill_mode = ProgressBar.FillMode.FILL_BEGIN_TO_END
	else:
		forwards_backwards_velocity_progress_bar.fill_mode = ProgressBar.FillMode.FILL_END_TO_BEGIN
	
	velocity_label.text = str(int(roundf(velocity))) + " m/s"
	
	throttle_progress_bar.value = absf(throttle)
	
	if throttle > 0:
		throttle_progress_bar.fill_mode = ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
	else:
		throttle_progress_bar.fill_mode = ProgressBar.FillMode.FILL_TOP_TO_BOTTOM
	
	max_velocity_progress_bar.value = current_max_velocity
	
