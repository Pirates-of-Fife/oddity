extends Node3D

var total_power_storage : float
var total_stored_power : float

func _ready():
	total_power_storage = 0
	
	for battery in get_children():
		total_power_storage += battery.total_power_storage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calculate_total_stored_power()

func request_power(power : float) -> float:
	var recieved_power : float
	
	for battery in get_children():
		recieved_power += battery.use_power(power)
		
		if (recieved_power == power):
			break
	
	return recieved_power

func calculate_total_stored_power():
	total_stored_power = 0
	
	for battery in get_children():
		total_stored_power += battery.current_charge
