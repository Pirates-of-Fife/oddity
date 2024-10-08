extends Node3D

var powered_components : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	powered_components = get_powered_components()

func get_powered_components() -> Array:
	var components : Array
	
	components.append(%PlayerInput)
	components.append(%SimpleFlightControlSystem)
	
	for cooler in %Components/Coolers.get_children():
		components.append(cooler)
	
	for shield in %"Components/Shield Generators".get_children():
		components.append(shield)
		
	components.append(%"Components/Jump Drive".get_child(0))
	
	for battery in %"Components/Power Components/Battery".get_children():
		components.append(battery)
	
	components.append(%Thrusters)
	
	return sort_components(components)

func sort_components(components : Array) -> Array:
	components.sort_custom(compare)
	
	return components

func compare(a, b):
	if a.power_priority == b.power_priority:
		return true
	elif a.power_priority < b.power_priority:
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_power_tick_rate_timeout():	
	%"Components/Power Components".reset_power()
	
	for component in powered_components:
		var recieved_power = %"Components/Power Components".request_power(component)
		
		component.recieve_power(recieved_power)
		
		#print()
		#print(str(component) + " " + str(component.recieved_power))
		
