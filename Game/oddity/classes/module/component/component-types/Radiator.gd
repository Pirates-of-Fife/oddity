extends Component

class_name Radiator

@export
var heat_colors : GradientTexture1D

@export
var cooling_capacity : float

var cooling_timer : Timer = Timer.new()

@export
var cooling_rate : float

@export_range(0, 1, 0.01)
var start_cooling_at_heat : float

@export
var radiator_animation : AnimationPlayer

@export
var heat_mesh : MeshInstance3D

@export
var heat_material : StandardMaterial3D

var ship_max_heat_capacity : float :
	get:
		if (module_slot == null):
			return 0

		return module_slot.vehicle.maximum_heat_capacity

var ship_current_heat : float :
	get:
		if (module_slot == null):
			return 0

		return module_slot.vehicle.current_heat

var ship_heat_ratio : float :
	get:
		if (module_slot == null):
			return 0

		var ship : Starship = module_slot.vehicle
		var ratio : float = 0

		var ratio_ship : float = (ship_current_heat) / (ship.maximum_heat_capacity)
		var ratio_cooler : float = 0

		if heat_sink_size != 0:
			ratio_cooler = (heat_sink_current_usage / heat_sink_size)
			ratio = (ratio_ship + ratio_cooler) / 2
		else:
			ratio = ratio_ship

		print("Ship: " + str(ratio_ship) + " Cooler: " + str(ratio_cooler) + str(" total ") + str(ratio))

		return ratio

func _ready() -> void:
	_radiator_ready()

func _process(delta: float) -> void:
	radiator_animation.play("heat")
	radiator_animation.seek(ship_heat_ratio)
	radiator_animation.pause()

	heat_material.emission = heat_colors.gradient.sample(ship_heat_ratio)
	heat_material.albedo_color = heat_colors.gradient.sample(ship_heat_ratio)

func _radiator_ready() -> void:
	initialize_collision_shape_automatically = false
	_component_ready()

	cooling_timer.one_shot = false
	cooling_timer.wait_time = cooling_rate
	cooling_timer.timeout.connect(cooling_timeout)
	add_child(cooling_timer)

	cooling_timer.start()

	heat_material = heat_mesh.get_active_material(0)
	heat_material.emission_enabled = true
	heat_material.emission = heat_colors.gradient.sample(0)
	heat_material.albedo_color = heat_colors.gradient.sample(0)
	heat_material.emission_energy_multiplier = 10

var heat_sink_size : float
var heat_sink_current_usage : float

func cooling_timeout() -> void:
	if module_slot == null:
		return

	heat_sink_size = module_slot.vehicle.current_heat_sink_capacity
	heat_sink_current_usage = module_slot.vehicle.current_heat_sink_usage

	if ship_current_heat < ship_max_heat_capacity * start_cooling_at_heat:
		module_slot.vehicle.remove_heat_from_heat_sink(cooling_capacity)
		return

	if ship_current_heat > ship_max_heat_capacity * 0.7:
		module_slot.vehicle.remove_heat(cooling_capacity)
		return

	if ship_current_heat <= 1000 and heat_sink_current_usage > ship_current_heat:
		module_slot.vehicle.remove_heat(cooling_capacity)
		return

	if heat_sink_size != 0:
		module_slot.vehicle.remove_heat_from_heat_sink(cooling_capacity / 2)
		module_slot.vehicle.remove_heat(cooling_capacity / 2)
	else:
		module_slot.vehicle.remove_heat(cooling_capacity)
