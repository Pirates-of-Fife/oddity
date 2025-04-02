@tool
extends Resource

class_name PlanetData

@export var size : float = 1.0 : set = set_size
@export var resolution : int = 5 : set = set_resolution
@export var terrain_layers : Array[PlanetNoise] : set = set_terrain_layers
@export var region_types : Array[PlanetBiome] : set = set_region_types
@export var region_noise : FastNoiseLite : set = set_region_noise
@export var region_strength : float = 1.0 : set = set_region_strength
@export var region_bias : float = 1.0 : set = set_region_bias
@export_range(0.0, 1.0) var region_transition : float = 1.0 : set = set_region_transition

var lowest_point : float = 99999.0
var highest_point : float = 0.0


func set_region_noise(value : FastNoiseLite) -> void:
	region_noise = value
	emit_signal("changed")
	if region_noise != null and not region_noise.is_connected("changed", on_modified):
			region_noise.connect("changed", on_modified)


func set_region_strength(value : float) -> void:
	region_strength = value
	emit_signal("changed")
func set_region_bias(value :float) -> void:
	region_bias = value
	emit_signal("changed")
func set_region_transition(value:float) -> void:
	region_transition = value
	emit_signal("changed")
func set_terrain_layers(value:Array[PlanetNoise]) -> void:
	terrain_layers = value
	emit_signal("changed")
	for layer :PlanetNoise in terrain_layers:
		if layer != null and not layer.is_connected("changed", on_modified):
			layer.connect("changed", on_modified)

func set_region_types(value:Array[PlanetBiome]) -> void:
	region_types = value
	if region_types.size() == 0:
		region_types[0] = PlanetBiome.new()
	for region:PlanetBiome in region_types:
		if region == null:
			region = PlanetBiome.new()
		if not region.is_connected("changed", on_modified):
			region.connect("changed", on_modified)
	
	emit_signal("changed")

const MAX_RESOLUTION : int = 100
const MIN_RESOLUTION : int = -MAX_RESOLUTION

func set_size(value:float) -> void:
	size = value
	emit_signal("changed")

func set_resolution(value:int) -> void:
	if value > MAX_RESOLUTION:
		value = MAX_RESOLUTION
	if value < MIN_RESOLUTION:
		value = MIN_RESOLUTION
	resolution = value
	emit_signal("changed")

func on_modified() -> void:
	emit_signal("changed")

func get_surface_point_legacy(position : Vector3) -> Vector3:
	var height : float = 0.0
	for layer:PlanetNoise in terrain_layers:
		var layer_height:float = layer.noise_map.get_noise_3dv(position)
		layer_height = layer_height + 1 / 2.0 * layer.amplitude
		layer_height = max(0.0, layer_height - layer.minh)
		height += layer_height
	return position * size * (height+1.0)

func generate_region_texture() -> ImageTexture:
	var texture:ImageTexture = ImageTexture.new()
	var image:Image = Image.new()
	var region_count : int = region_types.size()
	if region_count > 0:
		var pixel_data : PackedByteArray = []
		var texture_width : int = region_types[0].gradient_t.width
		for biome:PlanetBiome in region_types:
			pixel_data.append_array(biome.gradient_t.get_image().get_data())
		
		image = Image.create_from_data(texture_width, region_count, false, Image.FORMAT_RGBA8, pixel_data)
		
		texture.set_image(image)
		texture.resource_name = "Biome Texture"
	return texture

func get_region_blend_value(surface_point : Vector3) -> float:
	var vertical_position : float = (surface_point.y + 1.0) / 2.0
	vertical_position += ((region_noise.get_noise_3dv(surface_point*100.0)+1.0/2.0)-region_bias) * region_strength
	var total_regions : float = region_types.size()
	var blend_result : float = 0.0;
	var transition_width : float = region_transition / 2.0 + 0.0001
	for index:float in range(total_regions):
		var distance : float = vertical_position - region_types[index].start_h
		var influence:float = clamp(inverse_lerp(-transition_width, transition_width, distance), 0.0, 1.0)
		blend_result *= (1 - influence)
		blend_result += index * influence
	return blend_result / max(1.0, total_regions - 1.0)

func get_surface_point(sphere_point : Vector3) -> Vector3:
	var total_height : float = 0.0
	var base_height :float = 0.0
	if terrain_layers.size() > 0:
		base_height = (terrain_layers[0].noise_map.get_noise_3dv(sphere_point*100.0))
		base_height = (base_height + 1.0) / 2.0 * terrain_layers[0].amplitude
		base_height = max(0.0, base_height - terrain_layers[0].minh)
	for layer:PlanetNoise in terrain_layers:
		var masking :float = 1.0
		if layer.use_first_layer_as_mask:
			masking = base_height
		var layer_height:float = layer.noise_map.get_noise_3dv(sphere_point*100.0)
		layer_height = (layer_height + 1.0) / 2.0 * layer.amplitude
		layer_height = max(0.0, layer_height - layer.minh) * masking
		total_height += layer_height
	return sphere_point * size * (total_height+1.0)
