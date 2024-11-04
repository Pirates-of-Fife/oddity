@tool
extends Node3D


@export var resolution: int = 10 


@export var auto_update: bool = true

@export var shape_settings: ShapeSettings
@export var colour_settings: ColourSettings

#var shape_settings_foldout: bool = false
#var colour_settings_foldout: bool = false

var shape_generator: ShapeGenerator


var mesh_filters: Array = []
var terrain_faces: Array = []





func _ready():
	if shape_settings == null:
		shape_settings = ShapeSettings.new()
	if colour_settings == null:
		colour_settings = ColourSettings.new()
	generate_planet()

func _process(delta: float) -> void:
	# Optionally, you could call generate_mesh() on some condition or input
	pass

func set_resolution(value: int) -> void:
	resolution = clamp(value, 2, 256)
	initialize()
	generate_mesh()

func initialize() -> void:
	
	shape_generator = ShapeGenerator.new(shape_settings)
	if mesh_filters.size() == 0:
		mesh_filters.resize(6)
		
	terrain_faces.resize(6)

	var directions: Array = [
		Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK
	]

	for i in range(6):
		if mesh_filters[i] == null:
			var mesh_obj = MeshInstance3D.new()
			mesh_obj.name = "mesh"
			add_child(mesh_obj)
			mesh_filters[i] = mesh_obj
			
			var material = StandardMaterial3D.new() # Replace with your material as needed
			mesh_filters[i].material_override = material
			mesh_filters[i].mesh = ArrayMesh.new()

		terrain_faces[i] = TerrainFace.new(shape_generator, mesh_filters[i].mesh, resolution, directions[i])



func generate_planet():
	initialize()
	generate_mesh()
	generate_colours()

func on_shape_settings_updated():
	if auto_update:
		initialize()
		generate_mesh()

func on_colour_settings_updated():
	if auto_update:
		initialize()
		generate_colours()

func generate_mesh():
	for face in terrain_faces:
		face.construct_mesh()

func generate_colours():
	for m in mesh_filters:
		var material = m.material_override
		if material:
			material.albedo_color = colour_settings.planet_color
