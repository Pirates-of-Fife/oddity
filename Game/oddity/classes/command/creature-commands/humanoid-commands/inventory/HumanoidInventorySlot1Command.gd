extends HumanoidInventoryCommand

class_name HumanoidInventorySlot1Command

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Humanoid:
		control_entity.use_inventory_slot(1)
