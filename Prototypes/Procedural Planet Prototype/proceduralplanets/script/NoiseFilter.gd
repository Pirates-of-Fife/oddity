extends Node

class_name NoiseFilter

var settings: NoiseSettings
var noise: SimplexNoise

# Constructor for the NoiseFilter class
func _init(settings: NoiseSettings):
	self.settings = settings
	noise = SimplexNoise.new()  # Create an instance of the SimplexNoise class

# Evaluate noise based on a 3D point
func evaluate(point: Vector3) -> float:
	var noise_value = 0.0
	var frequency = settings.base_roughness
	var amplitude = 1.0

	# Loop through each layer of noise
	for i in range(settings.num_layers):
		var v = noise.evaluate(point * frequency + settings.centre)
		noise_value += (v + 1) * 0.5 * amplitude  # Scale the noise to [0, 1] and apply amplitude
		frequency *= settings.roughness
		amplitude *= settings.persistence

	noise_value = max(0, noise_value - settings.min_value)  # Clamp the value
	return noise_value * settings.strength  # Scale by strength
