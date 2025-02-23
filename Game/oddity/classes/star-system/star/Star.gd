extends StaticGameEntity

class_name Star

@export
var danger_distance : float

@export
var mesh : Node3D

@export
var rotation_speed : float = 1

var zone : PlayerDetectionZone = PlayerDetectionZone.new()

func _process(delta: float) -> void:
	mesh.rotate_y(rotation_speed * delta)


func _ready() -> void:
	add_child(zone)
	
	zone.activate_distance = danger_distance
	zone.deactivate_distance = danger_distance
	zone.update_time = 0.3
	
	zone.activate.connect(player_too_close)
	
func player_too_close(player : Player, entity : ControlEntity) -> void:
	if entity is Starship:
		entity.destroyed()
	else:
		player.die()
