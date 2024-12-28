extends Node3D

class_name AbyssalPortal

@export
var destination_star_system : PackedScene

var starship : Starship

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Starship and body == starship:
		get_tree().get_first_node_in_group("World").load_star_system(destination_star_system, starship, self)
		$Area3D.monitoring = false
		queue_free()
