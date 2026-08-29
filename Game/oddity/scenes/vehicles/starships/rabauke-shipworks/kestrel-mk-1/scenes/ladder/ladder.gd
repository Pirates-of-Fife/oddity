extends Node3D

func _on_bottom_interacted(player:Player, control_entity:ControlEntity) -> void:
	control_entity.global_position = $Top.global_position


func _on_top_interacted(player:Player, control_entity:ControlEntity) -> void:
	control_entity.global_position = $Bottom.global_position
