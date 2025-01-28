extends Node3D

class_name MarkerSprite

@export
var text : StringName : 
	set(value):
		text = value
		marker_sprite_2d.label.text = value
	get:
		return text
		
@export
var distance : float :
	set(value):
		var c : CreditHud = CreditHud.new()
		distance = value
		marker_sprite_2d.distance.text = str(c.convert_to_human_readable(distance as int)) + "m" 
		

@export
var marker_sprite_2d : MarkerSprite2d
