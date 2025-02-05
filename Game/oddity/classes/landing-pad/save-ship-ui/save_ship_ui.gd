extends Node3D

class_name SaveShipUi

@export
var landing_pad : LandingPad

var loadout_tools : LoadoutGenerator = LoadoutGenerator.new()

func _on_save_ship_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landing_pad.starship == null:
		return
	
	loadout_tools.save_loadout(landing_pad.starship)
	loadout_tools.save_loadout(landing_pad.starship, true, true, true)
	$AudioStreamPlayer3D.play()
	
