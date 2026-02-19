extends Node3D

class_name StarSystemMap3D

@export
var star_system_map : StarSystemMap

func update_map(current_system : StarSystemResource, jump_range : float) -> void:
	star_system_map.draw_connecting_lines_from_system(current_system, jump_range)
