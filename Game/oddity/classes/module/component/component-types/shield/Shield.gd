extends StaticBody3D

class_name Shield

signal shield_hit(damage : float)

@export_category("Technical Stuff")

@export
var game_entity : GameEntity

@export
var mesh_instance : MeshInstance3D

@export
var shield_break_sound : AudioStreamPlayer3D

@onready
var shield_material_resource : StandardMaterial3D = preload("res://classes/module/component/component-types/shield/ShieldMaterial.tres")

var alpha_max : float = 0.30

@onready
var hit_sound_scene : PackedScene = preload("res://classes/module/component/component-types/shield/ShieldHitSound.tscn")

var shield_material : StandardMaterial3D


func _ready() -> void:
	shield_material = shield_material_resource.duplicate()
	shield_material.albedo_color.a = 0
	mesh_instance.set_surface_override_material(0, shield_material)

func _physics_process(delta: float) -> void:
	shield_material.albedo_color.a -= 0.0015
	shield_material.albedo_color.a = clampf(shield_material.albedo_color.a, 0, alpha_max)


func take_damage(damage : float) -> void:

	
	shield_material.albedo_color.a += 0.02
	shield_material.albedo_color.a = clampf(shield_material.albedo_color.a, 0, alpha_max)
	
	var hit_sound : AudioStreamPlayer3D = hit_sound_scene.instantiate()
	add_child.call_deferred(hit_sound)
	
	shield_hit.emit(damage)
	
	
	
	
