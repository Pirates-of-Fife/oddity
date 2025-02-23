@tool
extends Node3D

@export var planetdata : PlanetData: 
	set(val):
		planetdata = val
		on_data_change()
		if planetdata != null and not planetdata.is_connected("changed", on_data_change):
			planetdata.connect("changed", on_data_change)

func _ready() -> void:
	on_data_change()

func on_data_change() -> void:
	planetdata.min_height = 99999.0
	planetdata.max_height = 0.0
	for child:Node in get_children():
		var face :PlanetMeshFace= child as PlanetMeshFace
		face.regen_mesh(planetdata)
