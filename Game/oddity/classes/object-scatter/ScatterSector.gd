extends Node

class_name ScatterSector

var transforms : Array = Array()
var lat_min : float
var lat_max : float
var lon_min : float
var lon_max : float

var angle_min : float
var angle_max : float

var average_position : Vector3 :
	get():
		if transforms.is_empty():
			return Vector3.ZERO
		
		var sum : Vector3 = Vector3.ZERO
		
		for transform : Transform3D in transforms:
			sum += transform.origin
			
		return sum / transforms.size()

var bounding_radius : float :
	get():
		if transforms.is_empty():
			return 0.0

		var center : Vector3 = average_position
		var max_dist_squared : float = 0.0

		for transform : Transform3D in transforms:
			var pos : Vector3 = transform.origin
			var dist_squared : float = center.distance_squared_to(pos)
			if dist_squared > max_dist_squared:
				max_dist_squared = dist_squared

		return sqrt(max_dist_squared)
