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
var fuel_capacity : float

@export_category("Structural Information")

@export
var health_points : float

@export
var integrity : float

@export
var current_fuel : float
var wear : float

var fuel_efficiency : float
var fuel_power : float
var fuel_heat_generation : float

# Called when the node enters the scene tree for the first time.
func _ready():
	refuel(fuel_capacity, "Hydrogen")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (current_fuel < 0):
		current_fuel = 0

func use_fuel(amount : float):
	current_fuel -= amount * get_process_delta_time()

# same as add_fuel but not adding fuel over time
func refuel(amount : float, fuel_type : String):	
	if ((amount + current_fuel) > fuel_capacity):
		return
	
	# Calculate the total amount of fuel after adding
	var total_fuel = current_fuel + amount 

	var type = get_node("FuelTypes/" + fuel_type)

	var efficiency = type.efficiency
	var power = type.power
	var heat_generation = type.heat_generation

	fuel_efficiency = ((current_fuel * fuel_efficiency) + (amount * efficiency)) / total_fuel
	fuel_power = ((current_fuel * fuel_power) + (amount * power)) / total_fuel
	fuel_heat_generation = ((current_fuel * fuel_heat_generation) + (amount * heat_generation)) / total_fuel
	
	# Update the current fuel amount
	current_fuel = total_fuel

func add_fuel(amount : float, fuel_type : String):
	amount = amount * get_process_delta_time()
	
	if ((amount + current_fuel) > fuel_capacity):
		return
		
	var total_fuel = current_fuel + amount 

	var type = get_node("FuelTypes/" + fuel_type)

	var efficiency = type.efficiency
	var power = type.power
	var heat_generation = type.heat_generation

	fuel_efficiency = ((current_fuel * fuel_efficiency) + (amount * efficiency)) / total_fuel
	fuel_power = ((current_fuel * fuel_power) + (amount * power)) / total_fuel
	fuel_heat_generation = ((current_fuel * fuel_heat_generation) + (amount * heat_generation)) / total_fuel
	
	# Update the current fuel amount
	current_fuel = total_fuel
