extends Resource

class_name StringVector

@export
var x : String
@export
var y : String
@export
var z : String

static func create(from : Vector3) -> StringVector:
	var v : StringVector = StringVector.new()
	
	v.x = String.num(from.x)
	v.y = String.num(from.y)
	v.z = String.num(from.z)
	
	return v
	
func toVector3() -> Vector3:
	return Vector3(float(x), float(y), float(z))