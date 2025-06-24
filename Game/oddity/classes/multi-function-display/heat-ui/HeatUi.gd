extends Node3D

class_name HeatUi

@export_category("UI")

@export
var heat_ui_2d : HeatUi2d

@export_category("Ship")

@export
var ship : Starship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.ready.connect(_ship_ready)

func _ship_ready() -> void:
	ship.heat_changed.connect(_on_heat_changed)
	heat_ui_2d.max_heat = ship.maximum_heat_capacity
	ship.cooler_update.connect(_on_cooler_update)
	ship.on_cooler_config_changed.connect(_on_cooler_configuration_changed)
	heat_ui_2d.max_cool = ship.current_heat_sink_capacity
	_on_cooler_configuration_changed()

func _on_heat_changed(heat : float) -> void:
	heat_ui_2d.current_heat = heat

func _on_cooler_update() -> void:
	heat_ui_2d.current_cool = ship.current_heat_sink_usage
	#print("UI: current cool: " + str(ship.current_heat_sink_usage))

func _on_cooler_configuration_changed() -> void:
	heat_ui_2d.max_cool = ship.current_heat_sink_capacity

	if ship.current_heat_sink_capacity == 0:
		heat_ui_2d.hide_cool_bar()
	else:
		heat_ui_2d.show_cool_bar()

	print(ship.current_heat_sink_capacity)
	#print("UI: current max cool: " + str(ship.current_heat_sink_capacity))
