extends Label3D

class_name TradeCreditLabel

@export
var credits : int :
	set(value):
		var credit_convert : CreditHud = CreditHud.new()
		
		text = credit_convert.convert_to_human_readable(value) + " Credits"
		
		credits = value
