extends Label

class_name CargoLabel

var credit_hud : CreditHud = CreditHud.new()

func set_cargo_text(cargo : CargoContainer) -> void:
	text = cargo.contents + " : " + credit_hud.convert_to_human_readable(cargo.value) + " Credits"
