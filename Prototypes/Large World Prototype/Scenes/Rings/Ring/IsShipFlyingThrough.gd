extends Node3D

@export
var course : Node3D

func _on_area_3d_body_entered(body):
	$FlyThroughTrigger/Area3D.set_deferred("monitoring", false)
	course.ship_flew_through_ring()

func enable_trigger():
	$FlyThroughTrigger/Area3D.monitoring = true
