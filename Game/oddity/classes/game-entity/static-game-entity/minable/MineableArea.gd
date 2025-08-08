extends Area3D

class_name MineableArea

func _process(delta: float) -> void:
	collision_layer = 1 << 8
	collision_mask = 1 << 8
