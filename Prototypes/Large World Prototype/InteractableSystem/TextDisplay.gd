extends Control

@export
var time_per_character : float = 0.05

@export
var fade_out_time : float = 2

var text_already_displaying : bool

@onready
var audio : AudioStreamPlayer = $AudioStreamPlayer

func show_text(text : String) -> void:
	if (text_already_displaying):
		return
	
	appear()
	
	audio.pitch_scale = 1
	
	for c in text:
		$ColorRect/RichTextLabel.text += c
		audio.play()
		set_random_pitch()
		await get_tree().create_timer(time_per_character).timeout
	
	await get_tree().create_timer(fade_out_time).timeout
	
	disappear()
	$ColorRect/RichTextLabel.text = ""

func set_random_pitch():
	audio.pitch_scale = randf_range(0.7, 0.9)


func appear():
	$AnimationPlayer.play("Appear")
	text_already_displaying = true

func disappear():
	$AnimationPlayer.play("Disappear")
	text_already_displaying = false
