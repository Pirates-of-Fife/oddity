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

@export
var heat_ui : HeatUi

@export
var targeting : StarshipTargetMFD

@export
var damaged_label : Label3D

@export
var super_cruise_label : Label3D

@export
var interior_lights : Node3D

@export
var damaged_fires : Node3D

@export
var destroyed_fires : Node3D

@export
var alarm_sound_player : AudioStreamPlayer3D

@export
var explosion_partcle : GPUParticles3D



var interior_shown : bool = true
var player_reference : Player

func _ready() -> void:
	RABS_Kestrel_Mk1_ready()

func on_super_cruise_charging() -> void:
	super_cruise_label.show()

func on_super_cruise_charging_stopped() -> void:
	super_cruise_label.hide()

func hide_interior() -> void:
	$Interior.hide()
	$Mesh/Interior.hide()
	$Modules/Components.hide()

func show_interior() -> void:
	$Interior.show()
	$Mesh/Interior.show()
	$Modules/Components.show()

func _process(delta: float) -> void:
	_RABS_Kestrel_Mk1_process(delta)

func _RABS_Kestrel_Mk1_process(delta : float) -> void:
	_starship_process(delta)

	if player == null:
		return

	var distance_to_player : float = (global_position - player_reference.control_entity.global_position).length_squared()

	if distance_to_player < 625:
		if !interior_shown:
			show_interior()
			interior_shown = true
	else:
		if interior_shown:
			hide_interior()
			interior_shown = false

	if relative_linear_velocity.length() >= cruise_speed and current_state == State.POWER_ON:
		if !$Interior/Bridge/CruiseLabel.visible:
			$Interior/Bridge/CruiseLabel.show()
			$Interior/Bridge/CruiseLabel/CruiseSound.play()
	else:
		if $Interior/Bridge/CruiseLabel.visible:
			$Interior/Bridge/CruiseLabel/CruiseSound.play()
			$Interior/Bridge/CruiseLabel.hide()

	if ship_name.to_lower() == "the sunk'n norwegian":
		$Decal.show()
	else:
		$Decal.hide()

	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Pitch/Blend3/blend_amount", actual_rotation_vector_unit.x )
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Vertical/Blend3/blend_amount", -actual_thrust_vector_unit.y)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Forwards/Blend3/blend_amount", -actual_thrust_vector_unit.z)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Lateral/Blend3/blend_amount", -actual_thrust_vector_unit.x)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Yaw/Blend3/blend_amount", -actual_rotation_vector_unit.y)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Roll/Blend3/blend_amount", -actual_rotation_vector_unit.z)



func RABS_Kestrel_Mk1_ready() -> void:
	super_cruise_engaged.connect(on_supercruise_engaged)
	super_cruise_disengaged.connect(on_supercruise_disengaged)
	state_changed_to_power_on.connect(on_power_on)
	state_changed_to_power_off.connect(on_power_off)

	state_changed_to_destroyed.connect(on_destroyed)
	change_to_damaged_state.connect(on_damaged)
	repaired.connect(on_repaired)

	alcubierre_drive_charging_started.connect(on_super_cruise_charging)
	alcubierre_drive_charging_ended.connect(on_super_cruise_charging_stopped)

	_starship_ready()

	player_reference = get_tree().get_first_node_in_group("Player")

	if current_state == State.POWER_OFF:
		$Interior/Bridge/ShieldAndHullUi3d.hide()
		$Interior/Bridge/VelocityMfd3d.hide()
		$Interior/Bridge/AbyssalMFD3d.hide()
		$Interior/Bridge/RabsControlSeat/Crosshair3d.hide()
		$Interior/Bridge/MassLockedLabel.hide()
		$Interior/Bridge/CruiseLabel.hide()
		heat_ui.hide()
		if damaged:
			$Interior/Bridge/DamagedLabel.hide()
		$Interior/Bridge/RadarDisplay.hide()
		$Interior/Bridge/PowerLabel.show()
		$Interior/Bridge/StarshipTargetMfd.hide()


func on_supercruise_engaged() -> void:
	velocity_mfd.hide()
	super_cruise_mfd.show()

func on_supercruise_disengaged() -> void:
	velocity_mfd.show()
	super_cruise_mfd.hide()

func update_ui() -> void:
	crosshair.yaw = -target_rotational_thrust_vector.y
	crosshair.pitch = -target_rotational_thrust_vector.x

	targeting.update(focused_starship)

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

	if is_mass_locked and current_state == State.POWER_ON:
		if !$Interior/Bridge/MassLockedLabel.visible:
			$Interior/Bridge/MassLockedLabel.show()
			$Interior/Bridge/MassLockedLabel/MassLockedSound.play()
	else:
		if $Interior/Bridge/MassLockedLabel.visible:
			$Interior/Bridge/MassLockedLabel.hide()
			$Interior/Bridge/MassLockedLabel/MassLockedSound.play()

func on_power_on() -> void:
	power_on_sound_player.play()

	$Interior/Bridge/ShieldAndHullUi3d.show()
	$Interior/Bridge/VelocityMfd3d.show()
	$Interior/Bridge/AbyssalMFD3d.show()
	$Interior/Bridge/RabsControlSeat/Crosshair3d.show()
	$Interior/Bridge/MassLockedLabel.show()
	$Interior/Bridge/CruiseLabel.show()
	heat_ui.show()

	if damaged:
		$Interior/Bridge/DamagedLabel.show()
	$Interior/Bridge/RadarDisplay.show()
	$Interior/Bridge/PowerLabel.hide()
	$Interior/Bridge/StarshipTargetMfd.show()

func on_power_off() -> void:
	power_off_sound_player.play()
	power_off()
	$Interior/Bridge/ShieldAndHullUi3d.hide()
	$Interior/Bridge/VelocityMfd3d.hide()
	$Interior/Bridge/AbyssalMFD3d.hide()
	$Interior/Bridge/RabsControlSeat/Crosshair3d.hide()
	$Interior/Bridge/MassLockedLabel.hide()
	$Interior/Bridge/CruiseLabel.hide()
	heat_ui.hide()
	if damaged:
		$Interior/Bridge/DamagedLabel.hide()
	$Interior/Bridge/RadarDisplay.hide()
	$Interior/Bridge/PowerLabel.show()
	$Interior/Bridge/StarshipTargetMfd.hide()


func update_abyssal_mfd() -> void:
	abyssal_mfd.set_current_system(current_star_system.system_name)
	abyssal_mfd.set_selected_system(selected_system.name)

func on_destroyed() -> void:
	for fire : GPUParticles3D in destroyed_fires.get_children():
		fire.start_fire()

	for light : Node3D in interior_lights.get_children():
		if light is OmniLight3D:
			light.light_color = interior_lights.red_color
			light.light_energy = interior_lights.dim_light_energy

	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.start_fire()

	alarm_sound_player.play()

	$ExplosionParticle.emitting = true


	velocity_mfd.hide()
	crosshair.hide()
	abyssal_mfd.hide()
	super_cruise_mfd.hide()
	shield_and_health_ui.hide()
	damaged_label.hide()

func on_repaired() -> void:
	for light : Node3D in interior_lights.get_children():
		if light is OmniLight3D:
			light.light_color = interior_lights.default_color
			light.light_energy = interior_lights.default_light_energy

	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.stop_fire()

	for fire : GPUParticles3D in destroyed_fires.get_children():
		fire.stop_fire()

	damaged_label.hide()

	alarm_sound_player.stop()

func on_damaged() -> void:
	for light : Node3D in interior_lights.get_children():
		if light is OmniLight3D:
			light.light_color = interior_lights.red_color
			light.light_energy = interior_lights.dim_light_energy


	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.start_fire()

	if alarm_sound_player.playing == false:
		alarm_sound_player.play()

	damaged_label.show()

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
		landing_gear_on = false
		landing_gear_retracted.emit()
	else:
		$Interior/Bridge/LandingGearLabel.show()
		landing_gear_on = true
		landing_gear_deployed.emit()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Projectile:
		body.activate_collision()
