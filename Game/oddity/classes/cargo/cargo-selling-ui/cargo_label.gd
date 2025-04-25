extends Label

class_name CargoLabel

var credit_hud : CreditHud = CreditHud.new()

func set_cargo_text(cargo : CargoContainer) -> void:
	text = cargo.contents + " : " + credit_hud.convert_to_human_readable(cargo.value) + " Credits"

func set_module_text(module : Module) -> void:
	var component_resource : ComponentResource = (module.module_resource as ComponentResource)
	
	text = component_resource.manufacturer + " " + component_resource.model + " : " + credit_hud.convert_to_human_readable(module.value) + " Credits"
