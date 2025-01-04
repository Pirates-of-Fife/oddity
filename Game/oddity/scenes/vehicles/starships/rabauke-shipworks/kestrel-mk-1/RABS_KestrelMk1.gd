extends Starship

class_name RABS_KestrelMk1

@export
var velocity_mfd : VelocityMFD3D

@export
var crosshair : Crosshair3d

@export
var abyssal_mfd : AbyssalMFD3D

@export
var super_cruise_mfd : SuperCruiseMFD3D

@export
var shield_and_health_ui : ShieldAndHullUi3D


func _ready() -> void:
	RABS_Kestrel_Mk1_ready()

func RABS_Kestrel_Mk1_ready() -> void:
	_starship_ready()
	
	super_cruise_engaged.connect(on_supercruise_engaged)
	super_cruise_disengaged.connect(on_supercruise_disengaged)
	
func on_supercruise_engaged() -> void:
	velocity_mfd.hide()
	super_cruise_mfd.show()
	
func on_supercruise_disengaged() -> void:
	velocity_mfd.show()
	super_cruise_mfd.hide()

func update_ui() -> void:
	crosshair.yaw = -target_rotational_thrust_vector.y
	crosshair.pitch = -target_rotational_thrust_vector.x

	velocity_mfd.forwards_velocity = local_linear_velocity.z
	velocity_mfd.lateral_velocity_right = abs(minf(local_linear_velocity.x, 0))
	velocity_mfd.lateral_velocity_left = maxf(local_linear_velocity.x, 0)
	velocity_mfd.vertical_velocity_up = maxf(local_linear_velocity.y, 0)
	velocity_mfd.vertical_velocity_down = abs(minf(local_linear_velocity.y, 0))
	velocity_mfd.max_velocity = ship_info.max_linear_velocity
	velocity_mfd.current_max_velocity = current_max_velocity
	velocity_mfd.throttle = target_thrust_vector.z
	velocity_mfd.velocity = local_linear_velocity.length()
	
	if travel_mode == StarshipTravelModes.TravelMode.SUPER_CRUISE:
		super_cruise_mfd.velocity = current_super_cruise_speed
		super_cruise_mfd.velocity_c = current_super_cruise_speed_in_c
		super_cruise_mfd.throttle = target_thrust_vector.z
		super_cruise_mfd.max_velocity = alcubierre_drive_slot.module.module_resource.max_speed
		
	shield_and_health_ui.max_hull_health = max_hull_health
	shield_and_health_ui.current_hull_health = current_hull_health
	
	shield_and_health_ui.current_shield_health = shield_current_health
	shield_and_health_ui.max_shield_health = shield_max_health
	
	shield_and_health_ui.cooldown_time = shield_cooldown_after_break
	shield_and_health_ui.current_cooldown = shield_cooldown_after_break_timer.time_left

	

func update_abyssal_mfd() -> void:	
	abyssal_mfd.set_current_system(current_star_system.system_name)
	abyssal_mfd.set_selected_system(selected_system.name)
	
func toggle_landing_gear() -> void:
	if $Exterior/LandingGear/RabsKestrelMk1LandingGear.state != 0 and $Exterior/LandingGear/RabsKestrelMk1LandingGear.state != 1:
		return
	
	$Exterior/LandingGear/RabsKestrelMk1LandingGear.toggle_open_state()
	$Exterior/LandingGear/RabsKestrelMk1LandingGear2.toggle_open_state()
	$Exterior/LandingGear/RabsKestrelMk1LandingGear3.toggle_open_state()
	
	$LandingCollision.disabled = !$LandingCollision.disabled
	$LandingCollision2.disabled = !$LandingCollision2.disabled
	$LandingCollision3.disabled = !$LandingCollision3.disabled
	
	if $Interior/Bridge/LandingGearLabel.visible:
		$Interior/Bridge/LandingGearLabel.hide()
	else:
		$Interior/Bridge/LandingGearLabel.show()
