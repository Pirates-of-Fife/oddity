extends Node3D

class_name TradeTerminalPowerOnAnimation

signal powered_on

func start_animation(station_name : String) -> void:
	$AnimationRoot/Label3D.text = station_name
	$AnimationPlayer.play("power_on")
	$AnimationPlayer.animation_finished.connect(animation_finished)
	
func animation_finished(anim_name : String) -> void:
	powered_on.emit()
	$AnimationPlayer.animation_finished.disconnect(animation_finished)
