extends Interactable

class_name Bed

@export
var vehicle : Vehicle

@export
var bed_index : int

@export
var player_spawn_position_marker : Marker3D

var player_spawn_position : Vector3 :
	get():
		if player_spawn_position_marker == null:
			return Vector3.ZERO
		
		return player_spawn_position_marker.global_position

func _ready() -> void:
	interacted.connect(_on_interact)
	skip_delay = true

func _on_interact(player : Player, control_entity : ControlEntity) -> void:
	var world : World = get_tree().get_first_node_in_group("World")
	
	world.bed_exit(bed_index)
