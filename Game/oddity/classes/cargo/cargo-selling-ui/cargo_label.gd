extends Label

class_name CargoLabel

var credit_hud : CreditHud = CreditHud.new()

func set_cargo_text(cargo : CargoContainer, station_markup : float = 1) -> void:
	text = cargo.contents + " : " + credit_hud.convert_to_human_readable(cargo.value * station_markup) + " Credits"

func set_module_text(module : GameEntity, station_markup : float = 1) -> void:
	if module is Module:
	
		var component_resource : ComponentResource = (module.module_resource as ComponentResource)

		text = component_resource.manufacturer + " " + component_resource.model + " : " + credit_hud.convert_to_human_readable(module.value * station_markup) + " Credits"
	else:
		text = module.entity_name + " : " + credit_hud.convert_to_human_readable(module.value * station_markup) + " Credits"
