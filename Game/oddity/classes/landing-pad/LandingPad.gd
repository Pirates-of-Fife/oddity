extends Area3D

class_name LandingPad

signal starship_landed(starship : Starship)
signal starship_took_off(starship : Starship)

@export
var starship : Starship

@export
var starship_spawn_marker : Marker3D

func _ready() -> void:
	_landing_pad_ready()

func _landing_pad_ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_starship_landing_gear_retracted() -> void:
	_check_landing_status()

func _on_starship_landing_gear_deployed() -> void:
	_check_landing_status()

func _on_starship_power_off() -> void:
	_check_landing_status()

func _on_starship_power_on() -> void:
	_check_landing_status()

func _on_starship_destroyed() -> void:
	_check_landing_status()

func _check_landing_status() -> void:
	if starship.current_state == Starship.State.POWER_OFF and starship.landing_gear_on == true:
		starship_landed.emit(starship)
		print("starship_landed")
	else:
		starship_took_off.emit(starship)
		print("starship_took_offü")
	
func _on_body_entered(body : Node3D) -> void:
	print(body)
	
	if body is Starship:
		if starship != null:
			return
		
		print("starship entered")
		
		starship = body
		
		starship.landing_gear_deployed.connect(_on_starship_landing_gear_deployed)
		starship.landing_gear_retracted.connect(_on_starship_landing_gear_retracted)
		starship.state_changed_to_power_on.connect(_on_starship_power_on)
		starship.state_changed_to_power_off.connect(_on_starship_power_off)
		starship.state_changed_to_destroyed.connect(_on_starship_destroyed)
	
func _on_body_exited(body : Node3D) -> void:
	if body is Starship:
		if body != starship:
			return
		
		starship.landing_gear_deployed.disconnect(_on_starship_landing_gear_deployed)
		starship.landing_gear_retracted.disconnect(_on_starship_landing_gear_retracted)
		starship.state_changed_to_power_on.disconnect(_on_starship_power_on)
		starship.state_changed_to_power_off.disconnect(_on_starship_power_off)
		starship.state_changed_to_destroyed.disconnect(_on_starship_destroyed)
		
		starship = null
		
		starship_took_off.emit(body)
		
