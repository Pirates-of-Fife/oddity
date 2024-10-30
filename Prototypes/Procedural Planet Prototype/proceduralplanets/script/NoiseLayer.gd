extends Resource

class_name NoiseLayer
# Properties for each layer of noise
var enabled: bool = true
var use_first_layer_as_mask: bool = false
var noise_settings: NoiseSettings = NoiseSettings.new()  # Default instance for safety
