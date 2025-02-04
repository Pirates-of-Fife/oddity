extends Node3D

class_name SpaceStation

@export
var station_name : StringName

@export
var space_station_zone : SpaceStationZone

@export
var space_station_zone_marker_sprite : MarkerSprite

func _ready() -> void:
	_space_station_ready()
	
func _space_station_ready() -> void:
	space_station_zone_marker_sprite.text = station_name
