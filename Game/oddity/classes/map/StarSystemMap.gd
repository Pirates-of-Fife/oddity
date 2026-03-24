@tool
extends Node2D

class_name StarSystemMap

@export_range(0, 200, 1, "or_greater", "suffix:ly")
var map_size : float = 50

@export
var set_systems : bool :
	set(value):
		_update_systems()
		
		draw_connecting_lines_from_system(from, ly)

@export
var line_color : Color

@export_range(0, 100, 0.1, "or_greater", "suffix:ly")
var ly : float

@export
var from : StarSystemResource

var sprite_size : float = 1080

func _ready() -> void:
	pass

func _update_systems() -> void:
	for system : Node in $Systems.get_children():
		if system is StarSystemMapIcon:
			system.update_icon_position()

func convert_ly_to_px_coords(ly : Vector2) -> Vector2:
	return (ly * sprite_size) / map_size
	
func get_icon(system_resource : StarSystemResource) -> StarSystemMapIcon:
	for system : Node in $Systems.get_children():
		if system is StarSystemMapIcon:
			if system.star_system_resource == system_resource:
				return system
	
	return null

func reset_lines() -> void:
	for node : Node in $Lines.get_children():
		node.queue_free()

func draw_connecting_lines_from_system(from : StarSystemResource, jump_range : float) -> void:
	reset_lines()
	
	for system : Node in $Systems.get_children():
		if system is StarSystemMapIcon:
			var distance : float = from.position.distance_to(system.star_system_resource.position)
			
			if distance <= jump_range and distance > 0:
				draw_connecting_line(from, system.star_system_resource)
				
func draw_connecting_line(from : StarSystemResource, to : StarSystemResource) -> void:
	var line : Line2D = Line2D.new()
	
	line.default_color = line_color
	
	if from == null:
		from = load("res://scenes/world/gateway/GatewayResource.tres")
	elif from.name.to_lower() == "empty" or from.name.is_empty():
		from = load("res://scenes/world/gateway/GatewayResource.tres")
		
	line.add_point(get_icon(from).position)
	line.add_point(get_icon(to).position)
	
	$Lines.add_child(line)
