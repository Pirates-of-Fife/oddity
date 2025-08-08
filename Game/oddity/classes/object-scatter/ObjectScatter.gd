extends Node

class_name ObjectScatter

func generate_planet_scatter_sectors(splits : int, sector_count : int, planet_radius : float, scale_multiplier : float, invert_scale : bool, scale_variance : float) -> Array:
	var sectors : Array = Array()
	
	var lattitude_splits : int = splits / 2
	var longitude_splits : int = splits / 2
	var radius : float = planet_radius - 1
	
	for lattitude_index : int in range(lattitude_splits):
		var lat_min : float = lerp(-PI / 2.0, PI / 2.0, float(lattitude_index) / lattitude_splits)
		var lat_max : float = lerp(-PI / 2.0, PI / 2.0, float(lattitude_index + 1) / lattitude_splits)
		
		for longitude_index : int in range(longitude_splits):
			var lon_min : float = lerp(-PI, PI, float(longitude_index) / longitude_splits)
			var lon_max : float = lerp(-PI, PI, float(longitude_index + 1) / longitude_splits)
		
			var sector : ScatterSector = ScatterSector.new()
			sector.lat_min = lat_min
			sector.lat_max = lat_max
			sector.lon_min = lon_min
			sector.lon_max = lon_max
		
			for i : int in sector_count:
				var s_min : float = sin(lat_min)
				var s_max : float= sin(lat_max)
				var sin_lat : float= randf_range(s_min, s_max)
				var lat : float = asin(sin_lat)
				
				var lon : float = randf_range(lon_min, lon_max)
				
				var x : float = radius * cos(lat) * cos(lon)
				var y : float = radius * sin(lat)
				var z : float = radius * cos(lat) * sin(lon)
				var pos : Vector3 = Vector3(x, y, z)
				
				var up : Vector3 = pos.normalized()
				var tangent : Vector3 = up.cross(Vector3.UP)
				if tangent.length() < 0.1:
					tangent = up.cross(Vector3(1, 0, 0))
				tangent = tangent.normalized()
				
				var right : Vector3 = tangent.cross(up).normalized()
				var forward : Vector3 = up.cross(right).normalized()
				
				var variance : float = randf_range(scale_multiplier - scale_multiplier * scale_variance, scale_multiplier + scale_multiplier * scale_variance)
				
				var spawn_xform : Transform3D = Transform3D()
				spawn_xform.basis.x = right * variance
				spawn_xform.basis.y = up * variance
				spawn_xform.basis.z = forward * variance
				spawn_xform.origin = pos
				
				var ang: float = randf_range(0.0, TAU)
				spawn_xform.basis = spawn_xform.basis.rotated(up, ang)
				
				if invert_scale:
					spawn_xform = spawn_xform.scaled(Vector3(-1,-1,-1))
				
				sector.transforms.append(spawn_xform)
				
			sectors.append(sector)
			
	return sectors

func generate_gas_giant_scatter_sectors(splits : int, sector_count : int, planet_radius : float, scale_multiplier : float, invert_scale : bool, scale_variance : float, density : Gradient) -> Array:
	var sectors : Array = Array()
	
	var half_radius : float = planet_radius / 2
	
	var lattitude_splits : int = splits / 2
	var longitude_splits : int = splits / 2
	var radius : float = half_radius - 1
	
	for lattitude_index : int in range(lattitude_splits):
		var lat_min : float = lerp(-PI / 2.0, PI / 2.0, float(lattitude_index) / lattitude_splits)
		var lat_max : float = lerp(-PI / 2.0, PI / 2.0, float(lattitude_index + 1) / lattitude_splits)
		
		for longitude_index : int in range(longitude_splits):
			var lon_min : float = lerp(-PI, PI, float(longitude_index) / longitude_splits)
			var lon_max : float = lerp(-PI, PI, float(longitude_index + 1) / longitude_splits)
		
			var sector : ScatterSector = ScatterSector.new()
			sector.lat_min = lat_min
			sector.lat_max = lat_max
			sector.lon_min = lon_min
			sector.lon_max = lon_max
		
			for i : int in sector_count:
				var s_min : float = sin(lat_min)
				var s_max : float= sin(lat_max)
				var sin_lat : float= randf_range(s_min, s_max)
				var lat : float = asin(sin_lat)
				
				var lon : float = randf_range(lon_min, lon_max)
				
				var x : float = radius * cos(lat) * cos(lon)
				var y : float = radius * sin(lat)
				var z : float = radius * cos(lat) * sin(lon)
				var pos : Vector3 = Vector3(x, y, z)
				
				var up : Vector3 = pos.normalized()
				var tangent : Vector3 = up.cross(Vector3.UP)
				if tangent.length() < 0.1:
					tangent = up.cross(Vector3(1, 0, 0))
				tangent = tangent.normalized()
				
				var right : Vector3 = tangent.cross(up).normalized()
				var forward : Vector3 = up.cross(right).normalized()
				
				var variance : float = randf_range(scale_multiplier - scale_multiplier * scale_variance, scale_multiplier + scale_multiplier * scale_variance)
				
				var spawn_xform : Transform3D = Transform3D()
				spawn_xform.basis.x = right * variance
				spawn_xform.basis.y = up * variance
				spawn_xform.basis.z = forward * variance
				
				var chosen_t: float
				var intensity: float
				var retries: int = 0
				var max_retries: int = 50

				while true:
					chosen_t = randf()
					
					intensity = density.sample(chosen_t).r
					
					if randf() <= intensity:
						break
						
					retries += 1
					
					if retries >= max_retries:
						chosen_t = 0.5
						intensity = density.sample(chosen_t).r
						break
						
				var vert: float = lerp(-half_radius, half_radius, chosen_t)
				
				spawn_xform.origin = pos + up.normalized() * vert
				
				var axis : Vector3 = Vector3(
					randf_range(0.0, 1.0),
					randf_range(0.0, 1.0),
					randf_range(0.0, 1.0)
				).normalized()
				
				var ang: float = randf_range(0.0, TAU)
				spawn_xform.basis = spawn_xform.basis.rotated(axis, ang)
				
				if invert_scale:
					spawn_xform = spawn_xform.scaled(Vector3(-1,-1,-1))
				
				sector.transforms.append(spawn_xform)
				
			sectors.append(sector)
			
	return sectors
	
func generate_asteroid_belt_scatter_sectors(splits : int, sector_count : int, asteroid_belt : AsteroidBelt, scale_multiplier : float, invert_scale : bool, scale_variance : float, vertical_variance : float) -> Array:
	var sectors: Array = []

	var raw_basis: Basis = asteroid_belt.global_transform.basis
	var rot_basis: Basis = raw_basis.orthonormalized()
	var belt_origin: Vector3 = asteroid_belt.global_transform.origin
	var belt_transform: Transform3D = Transform3D(rot_basis, belt_origin)

	var delta_angle: float = TAU / float(splits)

	for sector_index: int in range(splits):
		var angle_min: float = sector_index * delta_angle
		var angle_max: float = (sector_index + 1) * delta_angle

		var sector: ScatterSector = ScatterSector.new()
		sector.angle_min = angle_min
		sector.angle_max = angle_max

		for i: int in range(sector_count):
			var angle: float = randf_range(angle_min, angle_max)
			var radius: float = randf_range(asteroid_belt.inner_radius, asteroid_belt.outer_radius)

			var x: float = radius * cos(angle)
			var y: float = 0.0
			var z: float = radius * sin(angle)
			var pos: Vector3 = Vector3(x, y, z)

			var up: Vector3 = Vector3.UP
			var forward: Vector3 = Vector3(x, 0.0, z).normalized()
			if forward.length() < 0.1:
				forward = Vector3(1, 0, 0)
			var right: Vector3 = up.cross(forward).normalized()

			var variance: float = randf_range(
				scale_multiplier - scale_multiplier * scale_variance,
				scale_multiplier + scale_multiplier * scale_variance
			)
			var vert: float = randf_range(-vertical_variance * 0.5, vertical_variance * 0.5)

			var spawn_xform: Transform3D = Transform3D()
			spawn_xform.basis.x = right * variance
			spawn_xform.basis.y = up * variance
			spawn_xform.basis.z = forward * variance
			spawn_xform.origin = pos + Vector3(0, vert, 0)

			var axis : Vector3 = Vector3(
				randf_range(0.0, 1.0),
				randf_range(0.0, 1.0),
				randf_range(0.0, 1.0)
			).normalized()
			
			var ang: float = randf_range(0.0, TAU)
			spawn_xform.basis = spawn_xform.basis.rotated(axis, ang)

			spawn_xform = belt_transform * spawn_xform

			if invert_scale:
				spawn_xform = spawn_xform.scaled(Vector3(-1.0, -1.0, -1.0))

			sector.transforms.append(spawn_xform)
		sectors.append(sector)

	return sectors
