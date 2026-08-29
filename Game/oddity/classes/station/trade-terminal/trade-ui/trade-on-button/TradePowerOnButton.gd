extends InteractionButton

class_name TradePowerOnButton

signal power_switch_signal

func _ready() -> void:
	interacted.connect(_on_click)

func _on_click(player : Player, control_entity : ControlEntity) -> void:
	power_switch_signal.emit()
	
	if $ON.visible:
		$ON.hide()
		$OFF.show()
	else:
		$ON.show()
		$OFF.hide()
