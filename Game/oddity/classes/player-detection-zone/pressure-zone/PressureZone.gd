extends PlayerDetectionZone

class_name PressureZone

var pressure_heat_timer : Timer = Timer.new()

@export_range(0.1, 5, 0.1)
var damage_timer : float 

@export_range(100, 10000)
var pressure_heat : float = 0

@export
var pressure_damage_curve : Curve

var player_control_entity : ControlEntity

func _ready() -> void:
	_pressure_zone_ready()

func _pressure_zone_ready() -> void:
	_player_detection_zone_ready()

	activate.connect(_on_activate)
	deactivate.connect(_on_deactivate)
	
	pressure_heat_timer.autostart = false
	pressure_heat_timer.one_shot = false
	pressure_heat_timer.timeout.connect(_pressure_timer_timeout)
	add_child(pressure_heat_timer)
	
func _pressure_timer_timeout() -> void:
	print("HEATss")
	
	if (player.control_entity is Starship):
		var distance : float = get_player_distance()
		var damage_modifier : float =  distance / activate_distance
		var damage : float = pressure_damage_curve.sample(damage_modifier) * pressure_heat
		
		player.control_entity.add_heat(damage)
		print("SMG: " + str(damage))

func _on_activate(player : Player, control_entity : ControlEntity) -> void:
	pressure_heat_timer.start()
	if (player.control_entity is Starship):
		(player.control_entity as Starship).entered_pressure_zone.emit()

func _on_deactivate(player : Player, control_entity : ControlEntity) -> void:
	pressure_heat_timer.stop()
	if (player.control_entity is Starship):
		(player.control_entity as Starship).exited_pressure_zone.emit()
