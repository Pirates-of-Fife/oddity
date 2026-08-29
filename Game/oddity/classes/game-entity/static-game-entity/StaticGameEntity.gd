extends StaticBody3D

class_name StaticGameEntity

signal on_damage_taken(damage : float, penetration : float)

@export_category("Information")

@export
var entity_name : StringName = name

var world : World : 
	get:
		return get_tree().get_first_node_in_group("World")

# WARNING: temporary, damage will depend on penetration and armour values
func take_damage(damage : float, penetration : float) -> void:
	on_damage_taken.emit(damage, penetration)
