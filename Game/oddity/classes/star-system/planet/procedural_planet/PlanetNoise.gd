@tool
extends Resource
class_name PlanetNoise

@export var strength : float = 1.0 : set = set_strength
@export var min_height : float = 1.0 : set = set_min_height
@export var noise_generator : FastNoiseLite : set = set_noise_generator
@export var use_base_as_mask : bool = false : set = set_use_base_as_mask

func set_use_base_as_mask(value:bool) -> void:
	use_base_as_mask = value
	emit_signal("changed")

func set_strength(value:float) -> void:
	strength = value
	emit_signal("changed")

func set_min_height(value:float) -> void:
	min_height = value
	emit_signal("changed")

func set_noise_generator(value:FastNoiseLite) -> void:
	noise_generator = value
	if noise_generator != null and not noise_generator.is_connected("changed", on_modified):
		noise_generator.connect("changed", on_modified)

func on_modified() -> void:
	emit_signal("changed")
