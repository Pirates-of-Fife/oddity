extends Node3D

class_name MusicPlayer

@export_category("Battle Music")

@export
var battle_music : Array[MusicResource]

var current_audio_player : MusicStreamPlayer

func play_music(music : MusicResource) -> void:
	if current_audio_player != null:
		if current_audio_player.playing and !music.override_current_track:
			return
	
	var audio_player : MusicStreamPlayer = MusicStreamPlayer.new()
	
	add_child(audio_player)
	audio_player.play_track(music)
	
	if current_audio_player != null:
		current_audio_player.stop_track()
	
	current_audio_player = audio_player

func stop_music() -> void:
	current_audio_player.stop_track()

func play_random_battle_music() -> void:
	if battle_music == null:
		return
	
	if battle_music.size() <= 0:
		return
	
	play_music(battle_music.pick_random())
