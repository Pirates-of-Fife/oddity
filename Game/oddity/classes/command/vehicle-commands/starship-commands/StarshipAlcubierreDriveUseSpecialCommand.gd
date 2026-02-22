extends StarshipCommand

class_name StarshipAlcubierreDriveUseSpecialCommand

func execute(control_entity : ControlEntity, data : Object = null) -> void:
	if control_entity is Starship:
		var alcubierre_drive : AlcubierreDrive = control_entity.alcubierre_drive_slot.module
		
		if alcubierre_drive == null:
			return
		
		alcubierre_drive.use_special()
