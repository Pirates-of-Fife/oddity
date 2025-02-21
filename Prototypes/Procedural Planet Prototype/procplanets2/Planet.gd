@tool
extends Node3D

@export var planet_resource: PlanetResource:
	set(val):
		planet_resource = val
		on_data_changed()
		if planet_resource != null and not planet_resource.is_connected("changed", on_data_changed):
			planet_resource.connect("changed", on_data_changed)



func set_planet_data(val):
	planet_resource =val
	on_data_changed()
	if planet_resource != null and not planet_resource.is_connected("changed", on_data_changed):
			planet_resource.connect("changed", on_data_changed)


func _ready():
	on_data_changed()


func on_data_changed():
	planet_resource.min_height = 99999.0
	planet_resource.max_height = 0.0
	for child in get_children():
		var face:= child as PlanetMeshFace
		face.regenerate_mesh(planet_resource)
