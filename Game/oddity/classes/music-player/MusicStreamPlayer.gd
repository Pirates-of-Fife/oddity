extends AudioStreamPlayer

class_name MusicStreamPlayer

var music_track : MusicResource :
	get:
		return music_track
	set(value):
		music_track = value
		
		if value == null:
			return
			
		stream = value.music

const db_mute : float = -72

func _ready() -> void:
	bus = &"Music"
	finished.connect(_on_finished)

func _on_finished() -> void:
	if !music_track.loop:
		stop()
		queue_free()

func play_track(track : MusicResource) -> void:
	if track == null:
		return
	
	if playing and !track.override_current_track:
		return
	
	print("playing : " + str(track.music))
	
	music_track = track
	
	volume_db = db_mute
	var target_volume : float = Globals.music_volume + music_track.volume_modifier
	
	play()
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", target_volume, music_track.fade_in_time)

func stop_track() -> void:
	if !playing:
		return
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", db_mute, music_track.fade_out_time)
	tween.finished.connect(tween_finished)

func tween_finished() -> void:
	stop()
	music_track = null
	queue_free()
