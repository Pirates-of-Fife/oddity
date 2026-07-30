extends MiningLaser

func _on_weapon_inserted(slot : ModuleSlot) -> void:
	if slot is Hardpoint:
		if slot.size == ModuleSize.HardpointSize.SIZE_6 and size == ModuleSize.HardpointSize.SIZE_5:
			global_position.z = slot.global_position.z + -0.302
			global_position.y = slot.global_position.y + -0.516