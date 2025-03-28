@tool
extends MeshInstance3D
class_name PlanetMeshFace

@export var face_normal : Vector3

func generate_terrain_mesh(planet_data : PlanetData) -> void:
	var mesh_arrays : Array = []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	
	var vertices : PackedVector3Array = PackedVector3Array()
	var uv_coords : PackedVector2Array = PackedVector2Array()
	var normals : PackedVector3Array = PackedVector3Array()
	var indices : PackedInt32Array = PackedInt32Array()
	
	var grid_size : int = planet_data.res
	var vertex_count : int = grid_size * grid_size
	var triangle_count : int = (grid_size - 1) * (grid_size - 1) * 6
	
	normals.resize(vertex_count)
	uv_coords.resize(vertex_count)
	vertices.resize(vertex_count)
	indices.resize(triangle_count)
	
	var current_index : int = 0
	var tangent : Vector3 = Vector3(face_normal.y, face_normal.z, face_normal.x)
	var bitangent : Vector3 = face_normal.cross(tangent)
	
	for row : int in range(grid_size):
		for col : int in range(grid_size):
			var vertex_id : int = col + row * grid_size
			var grid_position : Vector2 = Vector2(col, row) / (grid_size - 1)
			
			var cube_point : Vector3 = face_normal + (grid_position.x - 0.5) * 2.0 * tangent + (grid_position.y - 0.5) * 2.0 * bitangent
			var sphere_point : Vector3 = cube_point.normalized() * planet_data.radius
			var region_value : float = planet_data.biome_percent_from_point(sphere_point)
			var surface_point : Vector3 = planet_data.point_on_planet(sphere_point)
			
			vertices[vertex_id] = surface_point
			uv_coords[vertex_id] = Vector2(0.0, region_value)
			
			var distance_from_center : float = surface_point.length()
			planet_data.min_height = min(planet_data.min_height, distance_from_center)
			planet_data.max_height = max(planet_data.max_height, distance_from_center)
			
			if col != grid_size - 1 and row != grid_size - 1:
				# First triangle
				indices[current_index + 2] = vertex_id
				indices[current_index + 1] = vertex_id + grid_size + 1
				indices[current_index] = vertex_id + grid_size
				
				# Second triangle
				indices[current_index + 5] = vertex_id
				indices[current_index + 4] = vertex_id + 1
				indices[current_index + 3] = vertex_id + grid_size + 1
				
				current_index += 6

	# Calculate smooth normals
	for i : int in range(0, indices.size(), 3):
		var a : int = indices[i]
		var b : int = indices[i + 1]
		var c : int = indices[i + 2]
		
		var edge_ab : Vector3 = vertices[b] - vertices[a]
		var edge_bc : Vector3 = vertices[c] - vertices[b]
		var edge_ca : Vector3 = vertices[a] - vertices[c]
		
		var normal_ab_bc : Vector3 = edge_ab.cross(edge_bc) * -1.0
		var normal_bc_ca : Vector3 = edge_bc.cross(edge_ca) * -1.0
		var normal_ca_ab : Vector3 = edge_ca.cross(edge_ab) * -1.0
		
		var face_normal : Vector3 = normal_ab_bc + normal_bc_ca + normal_ca_ab
		
		normals[a] += face_normal
		normals[b] += face_normal
		normals[c] += face_normal

	# Normalize all normals
	for i : int in range(normals.size()):
		normals[i] = normals[i].normalized()
	
	# Assign mesh arrays
	mesh_arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uv_coords
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	
	call_deferred("_apply_mesh_data", mesh_arrays, planet_data)

func _apply_mesh_data(mesh_data : Array, planet_data : PlanetData) -> void:
	var new_mesh : ArrayMesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
	
	self.mesh = new_mesh
	material_override.set_shader_parameter("min_height", planet_data.min_height)
	material_override.set_shader_parameter("max_height", planet_data.max_height)
	material_override.set_shader_parameter("height_color", planet_data.update_biome_texture())
