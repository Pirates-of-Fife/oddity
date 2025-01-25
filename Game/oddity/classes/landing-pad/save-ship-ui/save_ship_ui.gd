extends Node3D

class_name SaveShipUi

@export
var landing_pad : LandingPad

func _on_save_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landing_pad.starship == null:
		return
	
	
