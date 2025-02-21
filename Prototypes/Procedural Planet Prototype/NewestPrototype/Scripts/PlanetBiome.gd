@tool
extends Resource
class_name PlanetBiome

@export var gradient_t : GradientTexture1D : set = set_gradient
@export var start_h : float : set = set_start_h

func set_gradient(val):
	gradient_t = val
	emit_signal("changed")
	if gradient_t != null and not gradient_t.is_connected("changed", on_data_changed):
		gradient_t.connect("changed", on_data_changed)

func set_start_h(val):
	start_h = val
	emit_signal("changed")
func on_data_changed():
	emit_signal("changed")
