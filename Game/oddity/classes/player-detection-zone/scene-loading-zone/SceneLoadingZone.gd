extends PlayerDetectionZone

# Why didn't i create this class earlier... it could replace so many of hte otehr oiejfgskdjgsdjhgljds

class_name SceneLoadingZone

@export
var scene : PackedScene

var current_instance : Node3D

func _ready() -> void:
	_scene_loading_zone_ready()

func _scene_loading_zone_ready() -> void:
	_player_detection_zone_ready()
	
	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)

func _on_activate(player: Player, control_entity: ControlEntity) -> void:
	var instance : Node3D = scene.instantiate()
	current_instance = instance
	add_child(instance)

func _on_deactivate(player: Player, control_entity: ControlEntity) -> void:
	if current_instance != null:
		current_instance.queue_free()
