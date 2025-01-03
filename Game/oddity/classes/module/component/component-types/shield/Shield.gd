@icon("res://classes/multi-function-display/shield_and_hull_ui/ShieldIcon.svg")
extends StaticBody3D

class_name Shield

signal shield_hit(damage : float)

@export_category("Shield Effects")

@export
var shield_alpha_up_per_projectile : float =  0.02

@export
var shield_alpha_down_per_physics_tick : float = 0.0015

@export
var shield_color : Color

@export
var shield_offline_color : Color

@export_category("Technical Stuff")

@export
var game_entity : GameEntity

@export
var mesh_instance : MeshInstance3D

@export_flags_3d_physics
var layer_mask_online : int

@export_flags_3d_physics
var layer_mask_offline : int

@export
var shield_break_sound : AudioStreamPlayer3D

@export
var shield_online_sound : AudioStreamPlayer3D

@onready
var shield_material_resource : StandardMaterial3D = preload("res://classes/module/component/component-types/shield/ShieldMaterial.tres")

var alpha_max : float = 0.30

@onready
var hit_sound_scene : PackedScene = preload("res://classes/module/component/component-types/shield/ShieldHitSound.tscn")

var shield_material : StandardMaterial3D


func _ready() -> void:
	shield_material = shield_material_resource.duplicate()
	mesh_instance.set_surface_override_material(0, shield_material)
	shield_material.albedo_color = shield_color
	shield_material.albedo_color.a = 0
	shield_offline_color.a = 0
	
func _physics_process(delta: float) -> void:
	shield_material.albedo_color.a -= shield_alpha_down_per_physics_tick
	shield_material.albedo_color.a = clampf(shield_material.albedo_color.a, 0, alpha_max)

func set_color(color : Color) -> void:
	var last_a : float = shield_material.albedo_color.a
	shield_material.albedo_color = color
	shield_material.albedo_color.a = last_a


func take_damage(damage : float) -> void:
	shield_material.albedo_color.a += shield_alpha_up_per_projectile
	shield_material.albedo_color.a = clampf(shield_material.albedo_color.a, 0, alpha_max)
	
	var hit_sound : AudioStreamPlayer3D = hit_sound_scene.instantiate()
	add_child.call_deferred(hit_sound)
	
	shield_hit.emit(damage)
	
func on_shield_broken() -> void:
	if (game_entity as Starship).shield_max_health <= 0:
		return
	
	var last_a : float = shield_material.albedo_color.a
	shield_material.albedo_color = shield_offline_color
	shield_material.albedo_color.a = last_a
	collision_mask = layer_mask_offline
	
	shield_break_sound.play()

func on_shield_online() -> void:
	if (game_entity as Starship).shield_max_health <= 0:
		return
	
	shield_material.albedo_color = shield_color
	shield_material.albedo_color.a = 0.6
	collision_mask = layer_mask_online
	
	shield_online_sound.play()
	
