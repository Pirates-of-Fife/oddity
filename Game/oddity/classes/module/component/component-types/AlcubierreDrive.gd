extends Module

class_name AlcubierreDrive

@export_category("Alcubierre Drive")
@export
var size : ModuleSize.AlcubierreDriveSize

@export
var initialize_collision_shape_automatically : bool = true

@export
var manouvarabilty_curve : Curve

@export_category("Sounds")

@export
var charging_start : AudioStreamPlayer3D

@export
var charging_sound : AudioStreamPlayer3D

@export
var charging_end : AudioStreamPlayer3D

@export
var travelling_sound : AudioStreamPlayer3D

var started_charging : bool

func start_charging() -> void:
	charging_start.play()
	started_charging = true
		
func stop_charging() -> void:
	charging_sound.stop()
	charging_start.stop()
	charging_end.play()
	
	started_charging = false
	
func _on_charging_start_finished() -> void:
	if started_charging == true:
		charging_sound.play()
	
func super_cruise_start() -> void:
	travelling_sound.play()

func super_cruise_end() -> void:
	travelling_sound.stop()
	charging_end.stop()

func _ready() -> void:
	_alcubierre_drive_ready()

func _alcubierre_drive_ready() -> void:
	_module_ready()
		
	charging_start.finished.connect(_on_charging_start_finished)
	
	charging_start.stream = (module_resource as AlcubierreDriveResource).charging_start
	charging_sound.stream = (module_resource as AlcubierreDriveResource).charging_sound
	charging_end.stream = (module_resource as AlcubierreDriveResource).charging_end
	travelling_sound.stream = (module_resource as AlcubierreDriveResource).travelling_sound

	if initialize_collision_shape_automatically:
		_initialize_collision_shape()
	
func _initialize_collision_shape() -> void:
	var box_shape : BoxShape3D = BoxShape3D.new()
	
	var module_size : ModuleSize = ModuleSize.new()
	
	box_shape.size = module_size.get_alcubierre_drive_size(size)
	
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	
	collision_shape.shape = box_shape
		
	add_child(collision_shape)


func _on_timer_timeout() -> void:
	if (module_slot.vehicle != null):
		var ship : Starship = module_slot.vehicle
		
		if ship.travel_mode != StarshipTravelModes.TravelMode.SUPER_CRUISE:
			return
		
		var current_speed : float = ship.current_super_cruise_speed
		var max_speed : float = (module_resource as AlcubierreDriveResource).max_speed
		
		var fuel_multiplier : float = (module_resource as AlcubierreDriveResource).fuel_curve.sample(current_speed / max_speed)
		
		ship.current_fuel -= (module_resource as AlcubierreDriveResource).fuel_per_second * fuel_multiplier
