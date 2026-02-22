extends ComponentResource

class_name AbyssalJumpDriveResource

@export_category("Abyssal Jump Drive")

@export_range(0, 30, 0.1, "or_greater", "suffix:ly")
var jump_range : float

@export_range(0, 1000, 10, "or_greater")
var fuel_per_ly : float

@export
var fuel_usage_modifier : Curve

func get_fuel_usage(ly : float) -> float:
	print(fuel_per_ly * ly * fuel_usage_modifier.sample(ly / jump_range))
	print("fuel " + str(fuel_per_ly))
	print("ly " + str(ly))
	print("mod: " + str(fuel_usage_modifier.sample(ly / jump_range)))
	return fuel_per_ly * ly * fuel_usage_modifier.sample(ly / jump_range)
