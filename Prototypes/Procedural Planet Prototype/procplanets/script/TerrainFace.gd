extends Node3D
class_name TerrainFace

var shapegenerator: ShapeGenerator
var mesh: ArrayMesh
var resolution: int
var local_up: Vector3
var axis_a: Vector3
var axis_b: Vector3

# Constructor
func _init(shapegenerator: ShapeGenerator, mesh: ArrayMesh, resolution: int, local_up: Vector3) -> void:
	self.shapegenerator=shapegenerator
	self.mesh = mesh
	self.resolution = resolution
	self.local_up = local_up

	axis_a = Vector3(local_up.y, local_up.z, local_up.x)
	axis_b = local_up.cross(axis_a)

func construct_mesh() -> void:
	var vertices: PackedVector3Array = PackedVector3Array()  # Use PackedVector3Array for vertices
	var triangles: PackedInt32Array = PackedInt32Array()    # Use PackedInt32Array for triangles
	var normals: PackedVector3Array = PackedVector3Array()   # Use PackedVector3Array for normals

	for y in range(resolution):
		for x in range(resolution):
			var i: int = x + y * resolution
			var percent: Vector2 = Vector2(x, y) / (resolution - 1)
			var point_on_unit_cube: Vector3 = local_up + (percent.x - 0.5) * 2 * axis_a + (percent.y - 0.5) * 2 * axis_b
			var point_on_unit_sphere: Vector3 = point_on_unit_cube.normalized()
			vertices.append(shapegenerator.calculate_point_on_planet(point_on_unit_sphere))

			# Calculate the normal (unit vector pointing away from the origin)
			normals.append(shapegenerator.calculate_point_on_planet(point_on_unit_sphere))

			if x != resolution - 1 and y != resolution - 1:
				triangles.append(i)
				triangles.append(i + resolution + 1)
				triangles.append(i + resolution)

				triangles.append(i)
				triangles.append(i + 1)
				triangles.append(i + resolution + 1)

	# Remove existing surface if it exists
	if mesh.get_surface_count() > 0:
		mesh.remove_surface(0)

	# Prepare the arrays for add_surface_from_arrays
	var surface_arrays: Array = []
	surface_arrays.resize(ArrayMesh.ARRAY_MAX)
	surface_arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	surface_arrays[ArrayMesh.ARRAY_INDEX] = triangles
	surface_arrays[ArrayMesh.ARRAY_NORMAL] = normals

	# Add the surface with the packed arrays
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_arrays)
