@tool
extends Node3D

@export var planet_data: PlanetData

func _ready():
	if not planet_data:
		planet_data = PlanetData.new()
		planet_data.set_radius(100)
		planet_data.set_res(30)

		# Stelle sicher, dass das PlanetNoise-Array existiert
		planet_data.planet_noise = []
		
		# Erstelle und füge PlanetNoise hinzu
		var noise = PlanetNoise.new()
		noise.amplitude = 1.0
		noise.minh = 0.5
		noise.noise_map = FastNoiseLite.new()
		
		planet_data.planet_noise.append(noise)
		
		# Stelle sicher, dass das Biome-Array existiert
		planet_data.biomes = []
		
		# Erstelle und füge Biome hinzu
		var biome = PlanetBiome.new()
		biome.start_h = 0.2
		biome.gradient = GradientTexture1D.new()
		
		planet_data.biomes.append(biome)
		
		# Setze Biome-Noise-Einstellungen
		planet_data.biome_noise = FastNoiseLite.new()
		planet_data.biome_amplitude = 1.0
		planet_data.biome_offset = 0.5
		planet_data.biome_blend = 0.8

	generate_planet()

func generate_planet():
	# Entferne bestehende Planet-Mesh-Faces
	for child in get_children():
		child.queue_free()
	
	var directions = [
		Vector3.RIGHT, Vector3.LEFT, Vector3.UP,
		Vector3.DOWN, Vector3.FORWARD, Vector3.BACK
	]
	
	for dir in directions:
		var face = PlanetMeshFace.new()
		face.normal = dir
		add_child(face)
		face.owner = get_tree().edited_scene_root
	
	update_planet()

func update_planet():
	if not planet_data:
		return
	
	planet_data.min_height = 99999.0
	planet_data.max_height = 0.0
	
	for child in get_children():
		if child is PlanetMeshFace:
			child.regen_mesh(planet_data)
