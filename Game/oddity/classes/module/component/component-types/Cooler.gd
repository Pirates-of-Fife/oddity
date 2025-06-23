extends Component

class_name Cooler

var cooler_resource : CoolerResource

var cooling_interval_timer : Timer = Timer.new()

signal max_heat_reached

var current_stored_heat : float = 0 :
	set(value):
		current_stored_heat = clampf(value, 0, cooler_resource.heat_sink_size)

		if current_stored_heat == cooler_resource.heat_sink_size:
			max_heat_reached.emit()
			can_cool = false
		else:
			can_cool = true

		if module_slot.vehicle != null:
			module_slot.vehicle.cooler_update.emit()
	get():
		return current_stored_heat

var can_cool : bool = true

func _ready() -> void:
	_cooler_ready()

func _cooler_ready() -> void:
	_component_ready()
	cooler_resource = (module_resource as CoolerResource)

	cooling_interval_timer.autostart = true
	cooling_interval_timer.one_shot = false
	cooling_interval_timer.timeout.connect(_cooling_timer_timeout)
	cooling_interval_timer.wait_time = cooler_resource.cooling_interval
	add_child(cooling_interval_timer)


func _on_insert(slot : ModuleSlot) -> void:
	if slot.vehicle == null:
		return

	cooling_interval_timer.start()
	print("Cooler Inserterted")
	print(slot)

func _on_uninsert(slot : ModuleSlot) -> void:
	cooling_interval_timer.stop()
	print("cooler removed")

func _cooling_timer_timeout() -> void:
	if !can_cool:
		return

	if module_slot.vehicle.current_state == module_slot.vehicle.State.POWER_OFF:
		return

	if module_slot == null:
#		print("no cooler module slot")
		return

	#print("cooling timeout")

	if module_slot.vehicle.current_heat < cooler_resource.cooling_capacity * 1.8 or module_slot.vehicle.current_heat < 300:
		#print("skip")
		return

	if cooler_resource.cooling_capacity + current_stored_heat > cooler_resource.heat_sink_size:
		module_slot.vehicle.remove_heat(cooler_resource.heat_sink_size - current_stored_heat)
		current_stored_heat += cooler_resource.heat_sink_size - current_stored_heat
		return

	module_slot.vehicle.remove_heat(cooler_resource.cooling_capacity)
	current_stored_heat += cooler_resource.cooling_capacity
