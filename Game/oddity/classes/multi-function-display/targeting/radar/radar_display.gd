extends Node3D

class_name RadarDisplay

@export
var target_position_relative_to_ship : Vector3

@export
var starship : Starship

@export
var radar_blip_scene : PackedScene

@export
var targeted_radar_blip_scene : PackedScene

@export
var radar_radius : float

var radar_surrounding : RadarSurroundingArea
var radar_focus : RadarFocusArea

func _ready() -> void:
	radar_focus = starship.radar_focus_area
	radar_surrounding = starship.radar_surrounding_area
	radar_surrounding.entity_entered_radar_area.connect(_on_rader_area_entered)
	radar_surrounding.entity_exited_radar_area.connect(_on_radar_area_exited)
	
func update_radar_blips() -> void:
	for radar_blip : RadarBlip in $RadarBlips.get_children():
		if is_instance_valid(radar_blip):
			var relative_position : Vector3 = starship.to_local(radar_blip.entity.global_position)

			relative_position = log_transform(relative_position) 
			
			radar_blip.position = relative_position
			
			if radar_blip.entity is Starship:
				if (radar_blip.entity as Starship).is_targeted:
					radar_blip.set_target_material()
				else:
					radar_blip.set_default_material()

func log_transform(vec: Vector3) -> Vector3:
	var max_dist: float = 4000.0
	var min_dist: float = 10.0  # The reference point where it should be ~±0.1

	var transformed: Vector3 = Vector3()

	for i: int in 3:
		var value: float = vec[i]
		var sign: float = sign(value)  # Preserve direction
		var abs_value: float = abs(value)

		if abs_value <= 0:
			transformed[i] = 0.0
		else:
			var normalized: float = clamp((log(abs_value / min_dist) / log(max_dist / min_dist)), 0.0, 1.0)
			transformed[i] = sign * normalized  # Restore original direction

	return transformed


func _on_rader_area_entered(entity : GameEntity) -> void:
	var radar_blip : RadarBlip = radar_blip_scene.instantiate()
	radar_blip.entity = entity
	
	$RadarBlips.add_child(radar_blip)
	$BlipEnter.play()
	update_radar_blips()
	
func _on_radar_area_exited(entity : GameEntity) -> void:
	for radar_blip : RadarBlip in $RadarBlips.get_children():
		if radar_blip.entity == entity:
			radar_blip.queue_free()
			$BlipExit.play()
			update_radar_blips()
			

func _on_timer_timeout() -> void:
	update_radar_blips()
