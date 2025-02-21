extends StaticBody3D

class_name StaticGameEntity

signal on_damage_taken(damage : float)

# WARNING: temporary, damage will depend on penetration and armour values
func take_damage(damage : float) -> void:
	on_damage_taken.emit(damage)
