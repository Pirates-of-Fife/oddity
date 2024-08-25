extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_power_components_battery_ui_signal(percantage):
	$SubViewport/PowerBar2dui/BatteryCharge.value = percantage


func _on_power_components_powerplant_ui_signal(percentage):
	$SubViewport/PowerBar2dui/PowerPlantUsage.value = percentage
