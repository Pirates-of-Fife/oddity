extends Node3D

@onready
var animation_player = $AnimationPlayer

var ship_scale : bool

var prompt_showing : bool

@onready
var select_show_audio : AudioStreamPlayer3D = $SelectShow

@onready
var select_hide_audio : AudioStreamPlayer3D = $SelectHide

func show_prompt():
	if (prompt_showing):
		return
	
	if (ship_scale):
		animation_player.play("show_prompt_ship_scale")
		select_show_audio.play()
	else:
		animation_player.play("show_prompt")
		select_show_audio.play()
		
	prompt_showing = true

func hide_prompt():
	if (ship_scale):
		animation_player.play("hide_prompt_ship_scale")
		select_hide_audio.play()
	else:
		animation_player.play("hide_prompt")
		select_hide_audio.play()
		
	prompt_showing = false
