extends Node3D

var component_list : Array

signal powerplant_ui_signal(percentage : float)
signal battery_ui_signal(percantage : float)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("Power Usage")
	#print("Powerplant: " + str($"Power Plants".current_power_output) + " / " + str($"Power Plants".total_power_output))
	#print("Battery: " + str($Battery.total_stored_power) + " / " + str($Battery.total_power_storage))
	
	powerplant_ui_signal.emit($"Power Plants".current_power_output / $"Power Plants".total_power_output * 100)
	battery_ui_signal.emit($Battery.total_stored_power / $Battery.total_power_storage * 100)


func request_power(component : Node3D):	
	var powerplant_power = $"Power Plants".request_power(component.required_power)
	
	if (powerplant_power == 0):
		return $Battery.request_power(component.required_power)
	
	return powerplant_power
	 
	
func reset_power():
	$"Power Plants".reset_power_on_tick()


