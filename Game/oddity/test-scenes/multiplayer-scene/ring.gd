extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Starship:
		if body.can_heal == true and body.health < body.max_health:
			body.health = body.max_health
			body.get_node("CanHeal").hide()
			body.get_node("HealingTimer").start()
