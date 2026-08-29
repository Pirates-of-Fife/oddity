extends Node3D

class_name TractorBeamUpgradeUI

signal tractor_beam_upgraded

var upgraded : bool = false

func _ready() -> void:
	if upgraded:
		set_upgraded()
		
	var credit_hud : CreditHud = CreditHud.new()
	$Price.text = credit_hud.convert_to_human_readable(ShipUpgrades.tractor_beam_upgrade_price) + " Cr"

func _on_interaction_button_interacted(player:Player, control_entity:ControlEntity) -> void:
	if upgraded:
		return
	
	tractor_beam_upgraded.emit()
	set_upgraded()

func set_upgraded() -> void:
	$InteractionButton/GreenMesh.hide()
	$InteractionButton/RedMesh.show()
	$InteractionButton/ButtonLabel.text = "Acquired"