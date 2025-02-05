@tool
extends Node3D

# Exported variables for customization
@export var size: float = 10.0
@export var color: Color = Color(1.0, 1.0, 0.0)  # Default yellow
#@export var rotation_speed: float = 0.1  # Speed for rotating the texture/mesh

# Path to the external shader file
@export var shader_path: String = "res://Materials/sun_shader.gdshader"

# Private variables
var sphere_mesh : MeshInstance3D
var shader_material : ShaderMaterial
var shader : Shader

func _ready():
	# Create a sphere mesh to represent the sun
	sphere_mesh = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = size
	sphere.height = size * 2
	sphere_mesh.mesh = sphere
	sphere_mesh.position = Vector3.ZERO
	add_child(sphere_mesh)
	
	# Load the shader from the external file
	shader = load(shader_path) as Shader
	
	# Create a ShaderMaterial and assign the shader
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("sun_color", color)
	
	# Apply the shader material to the sphere mesh
	sphere_mesh.material_override = shader_material

func _process(delta: float):
	# Rotate the mesh slowly to simulate movement or animation
#	sphere_mesh.rotate_y(rotation_speed * delta)
	
	# Update the shader's time parameter for animation
	shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)  # Time-based animation
