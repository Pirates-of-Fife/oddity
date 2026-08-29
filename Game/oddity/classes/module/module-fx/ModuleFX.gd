extends GPUParticles3D

class_name ModuleFX

@export
var insert_sound : AudioStream

@export
var take_out_sound : AudioStream

var insert_fx : bool = true

var particles_finished : bool = false
var audio_finished : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if insert_fx:
		$AudioStreamPlayer3D.stream = insert_sound
	else:
		$AudioStreamPlayer3D.stream = take_out_sound
		
	emitting = true
	$AudioStreamPlayer3D.play()
	
func _on_finished() -> void:
	particles_finished = true

	if audio_finished:
		queue_free()

func _on_audio_stream_player_3d_finished() -> void:
	audio_finished = true
	
	if particles_finished:
		queue_free()
		
