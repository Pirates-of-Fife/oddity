extends Control

signal animation_started()

var started : bool = false

@export
var host : bool = true

func _ready() -> void:
	if !host:
		$Buttons/VBoxContainer/HostButton.disabled = true
		
	else:
		$Buttons/VBoxContainer/StartButton.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and started == false:
		$AnimationPlayer.play("start")
		started = true
		animation_started.emit()
