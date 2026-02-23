extends Resource

class_name MusicResource

@export_category("Audio")

@export
var music : AudioStream

@export_category("Settings")

@export_range(-15, 15, 0.1, "or_greater", "or_less", "suffix:db")
var volume_modifier : float

@export_range(0, 10, 0.1, "or_greater", "suffix:s")
var fade_in_time : float

@export_range(0, 10, 0.1, "or_greater", "suffix:s")
var fade_out_time : float

@export
var override_current_track : bool = true

@export
var loop : bool = true
