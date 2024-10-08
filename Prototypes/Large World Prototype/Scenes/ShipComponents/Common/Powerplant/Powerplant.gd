extends Node3D

@export_category("Manufacturer Information")

@export
var manufacturer : String

@export
var model : String

@export_category("Component Information")

@export_range(0, 10, 1)
var size_class : int

@export
var total_power_output : float

@export
var heat_per_power : float

@export
var fuel_per_power : float

@export_category("Structural Information")

@export
var health_points : float

@export
var integrity : float

var current_power_output : float
var current_heat : float
var current_fuel_usage : float
var wear : float

# Called when the node enters the scene tree for the first time.
func _ready():
	current_power_output = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_fuel_usage = fuel_per_power * current_power_output

func available_power() -> float:
	return total_power_output - current_power_output

func use_power(power : float) -> float:
	var available = available_power()
	
	if (available > 0):
		if ((current_power_output + power) <= total_power_output):
			current_power_output += power
			return power
		
		current_power_output += available
		
		return available
	
	return 0
			
