extends Node3D
class_name ShapeGenerator

var settings: ShapeSettings
var noise_filters: Array

# Constructor to initialize with ShapeSettings
func _init(settings: ShapeSettings):
	self.settings = settings
	noise_filters = []
	
	# Initialize noise filters based on the settings' noise layers
	for noise_layer in settings.noise_layers:
		if noise_layer.noise_settings:  # Ensure noise settings are valid
			var noise_filter = NoiseFilter.new(noise_layer.noise_settings)
			noise_filters.append(noise_filter)

# Function to calculate the point on the planet
func calculate_point_on_planet(point_on_unit_sphere: Vector3) -> Vector3:
	var first_layer_value: float = 0.0
	var elevation: float = 0.0

	# Check if there are any noise filters
	if noise_filters.size() > 0:
		first_layer_value = noise_filters[0].evaluate(point_on_unit_sphere)

		if settings.noise_layers[0].enabled:
			elevation = first_layer_value

	# Calculate elevation based on subsequent noise layers
	for i in range(1, noise_filters.size()):
		if settings.noise_layers[i].enabled:
			var mask: float = 1.0  # Default mask value
			if settings.noise_layers[i].use_first_layer_as_mask:
				mask = first_layer_value  # Use first layer value as mask if enabled
			
			elevation += noise_filters[i].evaluate(point_on_unit_sphere) * mask

	return point_on_unit_sphere * settings.planet_radius * (1.0 + elevation)
