extends Resource
class_name ShapeSettings

@export var planet_radius: float = 1.0
@export var height_scale: float = 1.0

# Declare `noise_layers` as a regular Array for editor export
@export var noise_layers: Array = []  # No specific type in the export annotation

# Constructor for ShapeSettings
func _init():
	var default_noise_layer = NoiseLayer.new()
	noise_layers.append(default_noise_layer)  # Add a default NoiseLayer instance

# Class to represent a noise layer
