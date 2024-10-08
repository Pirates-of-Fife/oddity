extends "res://Scenes/Spaceship/Common/Interfaces/I_PoweredComponent.gd"

@export_category("Manufacturer Information")

@export
var manufacturer : String

@export
var model : String

@export_category("Component Information")

@export_range(0, 10, 1)
var size_class : int

@export
var total_power_storage : float

@export
var heat_per_power : float

@export
var heat_per_charge : float

@export_category("Structural Information")

@export
var health_points : float

@export
var integrity : float

var current_charge : float
var current_power_output : float
var current_heat : float
var wear : float

@export
var charge_per_tick : float


# Called when the node enters the scene tree for the first time.
func _ready():
	power_priority = 8
	current_charge = 0

func _process(delta):
	pass

func use_power(power : float) -> float:
	if (current_charge > power):
		current_charge -= power
		
		return power
	
	if (current_charge < power):
		var p = current_charge
	
		current_charge = 0
		
		return p
	
	return 0
	
		

func recieve_power(power : float):
	current_charge += power
	recieved_power = power
	
	if (current_charge < total_power_storage):
		required_power = min(charge_per_tick, total_power_storage - current_charge) 
	else:
		required_power = 0
	
