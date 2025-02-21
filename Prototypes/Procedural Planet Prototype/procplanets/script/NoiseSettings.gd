extends Resource

class_name NoiseSettings  # Use class_name for exporting the class

# Properties for noise settings
@export var strength: float = 1.0
@export var num_layers: int = 1 
@export var base_roughness: float = 1.0
@export var roughness: float = 2.0
@export var persistence: float = 0.5
@export var centre: Vector3
@export var min_value: float = 0.0

# Method to set a limit on the number of layers in the inspector
func set_num_layers(value: int) -> void:
	num_layers = clamp(value, 1, 8)  # Ensure it stays between 1 and 8
