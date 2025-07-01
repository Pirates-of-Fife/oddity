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
				
				if invert_scale:
					spawn_xform = spawn_xform.scaled(Vector3(-1,-1,-1))
				
				sector.transforms.append(spawn_xform)
				
			sectors.append(sector)
			
	return sectors

func generate_gas_giant_scatter_sectors(splits : int, sector_count : int, planet_radius : float, scale_multiplier : float, invert_scale : bool, scale_variance : float) -> Array:
	return []

func generate_asteroid_belt_scatter_sectors() -> Array:
	return[]
