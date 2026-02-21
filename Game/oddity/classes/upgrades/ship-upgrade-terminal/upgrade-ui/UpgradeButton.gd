extends TradeChangeAmmountButtons

class_name UpgradeButton

@export
var upgrade_ui : UpgradeUI

func _add(player : Player, control_entity : ControlEntity) -> void:
	if player.credits < upgrade_ui.upgrade_price:
		play_decline_sound()
		return
	
	counter += 1
