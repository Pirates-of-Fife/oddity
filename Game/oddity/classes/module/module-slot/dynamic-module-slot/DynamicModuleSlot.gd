extends ModuleSlot

class_name DynamicModuleSlot

@export
var module : Module

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Module:
		if _module_fits(body) == true: 
			if body.is_being_held_after_uninsert == false:
				if body.module_slot == null:
					body.on_game_entity_drop_request.emit()
					body.insert(self)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Module:
		body.is_being_held_after_uninsert = false

func _module_fits(module : Module) -> bool:
	return false
