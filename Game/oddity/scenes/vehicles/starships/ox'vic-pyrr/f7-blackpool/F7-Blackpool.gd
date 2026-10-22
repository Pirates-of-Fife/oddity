extends Starship

class_name F7Blackpool

@export
var velocity_mfd : VelocityMFD3D

@export
var crosshair : Crosshair3d

@export
var abyssal_mfd : AbyssalMFD3D

@export
var star_system_map : StarSystemMap3D

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
var ammo_ui : AmmoUi3d

@export
var fuel_ui : FuelUi3d

@export
var interior_lights : Node3D

@export
var power_screen : RabaukePowerScreen

@export
var damaged_fires : Node3D

@export
var destroyed_fires : Node3D

@export
var alarm_sound_player : AudioStreamPlayer3D

@export
var explosion_partcle : GPUParticles3D

@export
var landing_cam : Sprite3D

@export
var cargo_bay : Openable

var interior_shown : bool = true
var player_reference : Player

func _ready() -> void:
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
	
	if is_bounty_target:
		landing_cam.get_children()[0].queue_free()
	
	player_reference = get_tree().get_first_node_in_group("Player")

	overheating_start.connect(_overheat_start)
	overheating_stop.connect(_overheat_stop)
	
	fuel_empty.connect(_on_fuel_empty)
	refueled.connect(_on_refueled)
	
	entered_pressure_zone.connect(_on_pressure_zone_entered)
	exited_pressure_zone.connect(_on_pressure_zone_exited)
	
	current_armour_health_changed.connect(_update_armour_ui)
	
	_update_armour_ui()
	
	if current_state == State.POWER_OFF:
		$UI/ShieldAndHullUi3d.hide()
		$UI/VelocityMfd3d.hide()
		$UI/AbyssalMFD3d.hide()
		$UI/Crosshair3d.hide()
		$UI/MassLockedLabel.hide()
		$UI/CruiseLabel.hide()
		$UI/LandingGearLabel.hide()
		landing_cam.hide()
		fuel_ui.hide()
		heat_ui.hide()
		if damaged:
			$UI/DamagedLabel.hide()
		$UI/RadarDisplay.hide()
		power_screen.set_state_power_off()
		$UI/StarshipTargetMfd.hide()
		ammo_ui.hide()
	else:
		power_screen.set_state_power_on()
		
	color_changed_to_dark.connect(_on_color_dark)
	color_changed_to_light.connect(_on_color_light)
	color_changed_to_white.connect(_on_color_white)
	
	if is_color_white(current_hull_material.albedo_color):
		_on_color_white()
	elif is_color_light(current_hull_material.albedo_color):
		_on_color_light()
	else:
		_on_color_dark()
		
func _process(delta: float) -> void:
	super._process(delta)
	_starship_process(delta)
		
	if player_reference == null:
		return

	var distance_to_player : float = (global_position - player_reference.global_position).length_squared()
		
	if distance_to_player < 25000:
		if !interior_shown:
			show_interior()
			interior_shown = true
	else:
		if interior_shown:
			hide_interior()
			interior_shown = false
	
	if landing_gear_on == true:
		current_max_velocity = 100
	
	if relative_linear_velocity.length() >= cruise_speed and current_state == State.POWER_ON:
		if !$UI/CruiseLabel.visible:
			$UI/CruiseLabel.show()
			$UI/CruiseLabel/CruiseSound.play()
	else:
		if $UI/CruiseLabel.visible:
			$UI/CruiseLabel.hide()
		
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Pitch/Blend3/blend_amount", actual_rotation_vector_unit.x )
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Vertical/Blend3/blend_amount", -actual_thrust_vector_unit.y)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Forwards/Blend3/blend_amount", -actual_thrust_vector_unit.z)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Lateral/Blend3/blend_amount", -actual_thrust_vector_unit.x)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Yaw/Blend3/blend_amount", -actual_rotation_vector_unit.y)
	$ThrusterAnimationPlayer/AnimationTree.set("parameters/Roll/Blend3/blend_amount", -actual_rotation_vector_unit.z)

func set_material_to_hull(material : StandardMaterial3D) -> void:
	$Mesh/Mesh/F7Blackpool_Paint/BalconyRearSection.get_surface_override_material(0).albedo_color = material.albedo_color
	$Mesh/Mesh/F7Blackpool_Paint/HullPaint.get_surface_override_material(0).albedo_color = material.albedo_color
	$Mesh/Mesh/F7Blackpool_Paint/Spoiler.get_surface_override_material(0).albedo_color = material.albedo_color
	
	current_hull_material = material

func on_super_cruise_charging() -> void:
	super_cruise_label.show()

func on_super_cruise_charging_stopped() -> void:
	super_cruise_label.hide()

func hide_interior() -> void:
	$Mesh/Mesh/F7Blackpool_Interior.hide()
	#$Modules/Components.hide()
	
func show_interior() -> void:
	$Mesh/Mesh/F7Blackpool_Interior.show()
	#$Modules/Components.show()
	
func _overheat_start() -> void:
	if (is_bounty_target):
		return

	$UI/OverheatLabel.show()

	for light : Node3D in interior_lights.get_children():
		if light is SpotLight3D:
			light.light_color = interior_lights.red_color
			light.light_energy = interior_lights.dim_light_energy

	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.start_fire()

	if !alarm_sound_player.playing:
		alarm_sound_player.play()


func _overheat_stop() -> void:
	if (is_bounty_target):
		return

	$UI/OverheatLabel.hide()

	if alarm_sound_player.playing:
		alarm_sound_player.stop()

	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.stop_fire()

	for light : Node3D in interior_lights.get_children():
		if light is SpotLight3D:
			light.light_color = interior_lights.default_color
			light.light_energy = interior_lights.default_light_energy
			
func _on_color_light() -> void:
	ship_identification_label.modulate = Color(0, 0, 0, 1)
	name_label.modulate = Color(0, 0, 0, 1)
	
	%Decal.texture_albedo = load("res://images/oxvic pyrr black.png")
	%Decal2.texture_albedo = load("res://images/F7 Black.png")
	%Decal3.texture_albedo = load("res://images/oxvic pyrr black.png")
			
func _on_color_white() -> void:
	ship_identification_label.modulate = Color(0, 0, 0, 1)
	name_label.modulate = Color(0, 0, 0, 1)
	
	%Decal.texture_albedo = load("res://images/oxvic pyrr color.png")
	%Decal2.texture_albedo = load("res://images/F7 Color.png")
	%Decal3.texture_albedo = load("res://images/oxvic pyrr color.png")

	
func _on_color_dark() -> void:
	ship_identification_label.modulate = Color(1, 1, 1, 1)
	name_label.modulate = Color(1, 1, 1, 1)
	
	%Decal.texture_albedo = load("res://images/oxvic pyrr white.png")
	%Decal2.texture_albedo = load("res://images/F7 White.png")
	%Decal3.texture_albedo = load("res://images/oxvic pyrr white.png")

func _on_pressure_zone_entered() -> void:
	$UI/PressureLabel.show()
	$UI/MassLockedLabel/MassLockedSound.play()
	
func _on_pressure_zone_exited() -> void:
	$UI/PressureLabel.hide()
	$UI/MassLockedLabel/MassLockedSound.play()
	
func _on_fuel_empty() -> void:
	$UI/ShieldAndHullUi3d.hide()
	$UI/VelocityMfd3d.hide()
	$UI/AbyssalMFD3d.hide()
	$UI/Crosshair3d.hide()
	$UI/MassLockedLabel.hide()
	$UI/CruiseLabel.hide()
	fuel_ui.hide()
	heat_ui.hide()
	if damaged:
		$UI/DamagedLabel.hide()
	$UI/RadarDisplay.hide()
	#$UI/PowerLabel.hide()
	power_screen.hide()
	$UI/StarshipTargetMfd.hide()
	$UI/LandingGearLabel.hide()
	ammo_ui.hide()
	
	for light : Node3D in interior_lights.get_children():
		if light is SpotLight3D:
			light.hide()
		
func _on_refueled() -> void:
	for light : Node3D in interior_lights.get_children():
		if light is SpotLight3D:
			light.show()
	power_screen.show()
			
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

	if active_frame_of_reference != null and (active_frame_of_reference is GravityGrid or active_frame_of_reference is GravityWell) and current_state == State.POWER_ON:
		$UI/GravityLabel.show()
		
		if (active_frame_of_reference is GravityGrid):
			$UI/GravityLabel.text = str( roundf( (active_frame_of_reference.gravity_strength) * 10) / 10) + " G"
		else:
			$UI/GravityLabel.text = str( roundf( (active_frame_of_reference.gravity_strength / 9.8) * 10) / 10) + " G"
	else:
		$UI/GravityLabel.hide()
	
	if is_mass_locked and current_state == State.POWER_ON:
		if !$UI/MassLockedLabel.visible:
			$UI/MassLockedLabel.show()
			$UI/MassLockedLabel/MassLockedSound.play()
		
		
		if active_frame_of_reference is GravityWell:
			$UI/AltLabel.show()
			$UI/AltLabel.text = "ALT: " + str(roundf(altitude))
	else:
		if $UI/MassLockedLabel.visible:
			$UI/MassLockedLabel.hide()
			$UI/MassLockedLabel/MassLockedSound.play()
			$UI/AltLabel.hide()

			
func on_power_on() -> void:
	_update_armour_ui()

	power_on_sound_player.play()
	power_screen.power_on()

	var ui_elements : Array = [
		$UI/ShieldAndHullUi3d,
		$UI/VelocityMfd3d,
		$UI/AbyssalMFD3d,
		$UI/Crosshair3d,
		#$UI/MassLockedLabel,
		$UI/CruiseLabel,
		fuel_ui,
		heat_ui,
		$UI/RadarDisplay,
		$UI/StarshipTargetMfd,
		ammo_ui
	]

	if damaged:
		ui_elements.append($UI/DamagedLabel)
	if landing_gear_on:
		ui_elements.append($UI/LandingGearLabel)
		ui_elements.append(landing_cam)
	if headlight_left.visible:
		ui_elements.append(headlight_icon)
	
	await get_tree().create_timer(3.5).timeout
	
	var boot_time : float = 0.5
	var flicker_interval : float = 0.05
	var elapsed : float = 0.0

	while elapsed < boot_time:
		for element : Node3D in ui_elements:
			element.visible = randi() % 2 == 0
		await get_tree().create_timer(flicker_interval).timeout
		elapsed += flicker_interval

	for element : Node3D in ui_elements:
		element.show()


func on_power_off() -> void:
	power_off_sound_player.play()
	power_off()
	$UI/ShieldAndHullUi3d.hide()
	$UI/VelocityMfd3d.hide()
	$UI/AbyssalMFD3d.hide()
	$UI/Crosshair3d.hide()
	$UI/MassLockedLabel.hide()
	$UI/CruiseLabel.hide()
	heat_ui.hide()
	fuel_ui.hide()
	$UI/AltLabel.hide()
	$UI/GravityLabel.hide()
	$UI/LandingGearLabel.hide()
	headlight_icon.hide()
	
	landing_cam.hide()
	
	if damaged:
		$UI/DamagedLabel.hide()
	$UI/RadarDisplay.hide()
	power_screen.power_off()
	$UI/StarshipTargetMfd.hide()
	ammo_ui.hide()

func update_abyssal_mfd() -> void:
	abyssal_mfd.set_current_system(current_star_system.system_name)
	abyssal_mfd.set_selected_system(selected_system.name)
	
	var current_system_resource : StarSystemResource = (get_tree().get_first_node_in_group("World") as World).get_current_star_sytem_resource()
	
	var dist : float = (get_tree().get_first_node_in_group("World") as World).calculate_star_system_distance(current_system_resource, selected_system)
	abyssal_mfd.set_distance(dist)
	distance_to_target_star_system = dist
	
	star_system_map.update_map(current_system_resource, jump_range)
	
	
func on_destroyed() -> void:
	for light : Node3D in interior_lights.get_children():
		if light is SpotLight3D:
			light.light_color = interior_lights.red_color
			light.light_energy = interior_lights.dim_light_energy
			
	if !destroyed_on_load:
		for fire : GPUParticles3D in destroyed_fires.get_children():
			fire.start_fire()
		for fire : GPUParticles3D in damaged_fires.get_children():
			fire.start_fire()

	alarm_sound_player.play()

	if !destroyed_on_load:
		$States/ExplosionParticle.emitting = true

	power_screen.hide()
	velocity_mfd.hide()
	crosshair.hide()
	abyssal_mfd.hide()
	super_cruise_mfd.hide()
	shield_and_health_ui.hide()
	damaged_label.hide()
	
	await get_tree().create_timer(20).timeout
	
	for fire : GPUParticles3D in destroyed_fires.get_children():
		fire.stop_fire()
	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.stop_fire()

func on_repaired() -> void:
	for light : Node3D in interior_lights.get_children():
		if light is SpotLight3D:
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
		if light is SpotLight3D:
			light.light_color = interior_lights.red_color
			light.light_energy = interior_lights.dim_light_energy

	for fire : GPUParticles3D in damaged_fires.get_children():
		fire.start_fire()

	if alarm_sound_player.playing == false:
		alarm_sound_player.play()

	damaged_label.show()

func toggle_landing_gear(force : bool = false) -> void:
	if $LandingGear/F7FrontLandingGear.state != 0 and $LandingGear/F7FrontLandingGear.state != 1:
		return

	$LandingGear/F7FrontLandingGear.toggle_open_state()
	$LandingGear/F7LeftLandingGear.toggle_open_state()
	$LandingGear/F7RightLandingGear.toggle_open_state()

	$LandingCollision.disabled = !$LandingCollision.disabled
	$LandingCollision2.disabled = !$LandingCollision2.disabled
	$LandingCollision3.disabled = !$LandingCollision3.disabled
	$LandingCollision4.disabled = !$LandingCollision4.disabled

	if $UI/LandingGearLabel.visible:
		$UI/LandingGearLabel.hide()
		landing_gear_on = false
		landing_cam.hide()
		landing_gear_retracted.emit()
	else:
		$UI/LandingGearLabel.show()
		landing_gear_on = true
		landing_cam.show()
		landing_gear_deployed.emit()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Projectile:
		body.activate_collision()

func toggle_tractor_beams() -> void:
	pass


func toggle_cargo_bay() -> void:
	cargo_bay.toggle_open_state()

		
func _update_armour_ui() -> void:
	shield_and_health_ui.current_armour_rating = current_armour_rating
	shield_and_health_ui.current_armour_health = current_armour_health
	shield_and_health_ui.max_armour_health = max_armour_health
	shield_and_health_ui._update_armour()
