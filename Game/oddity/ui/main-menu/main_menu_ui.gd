extends Control

signal animation_started()

var started : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and started == false:
		$AnimationPlayer.play("start")
		started = true
		animation_started.emit()
		$Click2.play()

func press_sound() -> void:
	$ButtonClick.play()

func _on_start_button_pressed() -> void:
	press_sound()

func _on_credits_button_pressed() -> void:
	press_sound()


func _on_exit_button_pressed() -> void:
	press_sound()


func _on_back_pressed() -> void:
	press_sound()
