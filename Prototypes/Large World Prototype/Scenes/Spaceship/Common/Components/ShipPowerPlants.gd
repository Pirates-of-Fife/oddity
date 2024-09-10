extends Node3D

var total_power_output : float
var current_power_output : float
var current_fuel_usage : float

var fuel_tanks : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	total_power_output = count_total_power_output()
	fuel_tanks = get_parent_node_3d().get_parent_node_3d().get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_power_output = count_current_power_output()
	current_fuel_usage = calculate_fuel_usage()
	
	if (fuel_tanks.current_fuel_capacity > 0):
		fuel_tanks.use_fuel(current_fuel_usage)

func request_power(power : float) -> float:
	var recieved_power : float
	
	for power_plant in get_children():
		recieved_power += power_plant.use_power(power)
		
		if (recieved_power == power):
			break
	
	return recieved_power
	
func reset_power_on_tick():
	for p in get_children():
		p.current_power_output = 0

func calculate_fuel_usage() -> float:
	var fuel = 0.0
	
	for power_plant in get_children():
		fuel += power_plant.current_fuel_usage
	
	return fuel

func count_total_power_output() -> float:
	var power = 0.0
	
	for power_plant in get_children():
		power += power_plant.total_power_output
	
	return power

func count_current_power_output() -> float:
	var power = 0.0
	
	for power_plant in get_children():
		power += power_plant.current_power_output
	
	return power
	
