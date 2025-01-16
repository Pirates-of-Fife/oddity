@tool
extends AnimationPlayer

class_name ThrusterAnimationTool

@export
var starship : Starship

@export
var generate_animations : bool :
	set(value):
		generate()
		

func generate() -> void:
	pass
	
	
	

# 	collision_shape.owner = get_tree().edited_scene_root
