extends Node3D

var total_fuel_capacity : float
var count_fuel_tanks : int

var current_fuel_capacity : float

var current_active_fuel_tank : Node3D

signal set_fuel_tank(fuel_tank : int)

# Called when the node enters the scene tree for the first time.
func _ready():
	select_fuel_tank_automatically()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	total_fuel_capacity = count_fuel()
	current_fuel_capacity = get_current_fuel_capacity()
	
	if (Input.is_key_pressed(KEY_1)):
		select_fuel_tank(1)
		
	if (Input.is_key_pressed(KEY_2)):
		select_fuel_tank(2)
	
	#print(str($FuelTank) + " " + str($FuelTank.fuel_efficiency) + " " + str($FuelTank.fuel_power) + " " + str($FuelTank.fuel_heat_generation) + " " + str("Fuel tank 1: ") + str($FuelTank.current_fuel) + str(" Fuel Tank 2: ") + str($FuelTank2.current_fuel))

func count_fuel() -> float:
	var fuel : float
	
	for fuel_tank in get_children():
		fuel += fuel_tank.fuel_capacity
	
	return fuel

func select_fuel_tank(fuel_tank : int):
	current_active_fuel_tank = get_children()[fuel_tank - 1]
	
	set_fuel_tank.emit(fuel_tank)

func select_fuel_tank_automatically():
	for fuel_tank in get_children():
		if (fuel_tank.current_fuel > 0):
			current_active_fuel_tank = fuel_tank
			return

func use_fuel(amount : float):
	if (current_fuel_capacity <= 0):
		return
	
	if (current_active_fuel_tank.current_fuel - amount < 0):
		amount = amount - current_active_fuel_tank.current_fuel
		current_active_fuel_tank.current_fuel = 0
		
		select_fuel_tank_automatically()
	
	current_active_fuel_tank.use_fuel(amount)
	
	
func get_current_fuel_capacity():
	var fuel : float
	
	for fuel_tank in get_children():
		fuel += fuel_tank.current_fuel
	 
	return fuel
