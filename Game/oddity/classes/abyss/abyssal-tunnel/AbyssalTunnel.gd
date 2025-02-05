@tool
extends Node3D

class_name AbyssalTunnel


var tunnel_material : StandardMaterial3D

@export
var tunnel_mesh : MeshInstance3D

@export
var offset_velocity : float = 0.1

var destination_star_system : PackedScene
var starship : Starship

@export
var starship_movement_step : float = 1

var world : World

@export
var abyssal_ambiance_scene : PackedScene = preload("res://classes/abyss/abyss/AbyssalAmbiance.tscn")

var abyssal_ambiance : AbyssalAmbiance

func _ready() -> void:
	tunnel_material = tunnel_mesh.get_active_material(0)
	world = get_tree().get_first_node_in_group("World")
	abyssal_ambiance = abyssal_ambiance_scene.instantiate()
	world.add_child(abyssal_ambiance)
	$EnterExitPlayer.play()

func _process(delta: float) -> void:
	tunnel_material.uv1_offset.z += offset_velocity * delta
	tunnel_material.uv1_offset.y += offset_velocity / 6 * delta

func _physics_process(delta: float) -> void:
	if starship != null:
		starship.global_position += starship.global_transform.basis.z * starship_movement_step * delta
		#starship.global_transform.origin 
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	world.unload_tunnel(self)
	$StaticBody3D/Exit.set_deferred("monitoring", false)
	abyssal_ambiance.stop_playing()
	$EnterExitPlayer.play_exit()
	
func _on_entrance_body_entered(body: Node3D) -> void:
	if body is Starship:
		starship = body
		$StaticBody3D/Entrance.set_deferred("monitoring", false)

func _on_mid_point_body_entered(body: Node3D) -> void:
	world.load_new_system(destination_star_system, starship)
	
	$StaticBody3D/MidPoint.set_deferred("monitoring", false)
