@tool
extends PlayerDetectionZone

class_name SpaceStationLoadingZone

@export
var scene : PackedScene

@export
var station_name : StringName

var station : SpaceStation

@export
var player_spawn_marker : Marker3D

@export
var ship_spawn_marker : Marker3D

@export_category("Tools")

@export
var active_editor : bool : 
	set(value):
		_on_activate(null, null)

@export
var deactive_editor : bool : 
	set(value):
		_on_deactivate(null, null)

func _ready() -> void:
	_space_station_loading_zone()

func _space_station_loading_zone() -> void:
	_player_detection_zone_ready()

	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)
	
	$MarkerSprite.text = station_name
	
	

func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	station = scene.instantiate()
	station.station_name = station_name
	add_child(station)
	

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	station.queue_free()
