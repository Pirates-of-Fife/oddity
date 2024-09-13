extends Node3D

@export
var RingMarker : Node3D

var course_rings = Array()
var rings_flown_through = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in $Rings.get_children ():
		course_rings.append(_i)


func ship_flew_through_ring():	
	if (rings_flown_through == 0):
		RingMarker.show()
	
	if (rings_flown_through == (course_rings.size() - 1)):
		
		rings_flown_through = 0
		RingMarker.hide()
		
		for _i in course_rings:
			_i.enable_trigger()
		
		return 0;
		
	rings_flown_through += 1
	
	RingMarker.global_position = course_rings[rings_flown_through].global_position
	RingMarker.rotation = course_rings[rings_flown_through].rotation + Vector3(0, 0, 1.5708)
	
