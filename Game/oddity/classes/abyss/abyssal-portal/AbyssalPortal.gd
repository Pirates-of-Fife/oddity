extends Node3D

class_name AbyssalPortal

@export
var destination_star_system : PackedScene

var starship : Starship

var tunnel_material : StandardMaterial3D

@export
var openable : Openable

@export
var tunnel_mesh : MeshInstance3D

@export
var offset_velocity : float = 0.1

@export
var open_sound : AudioStreamPlayer

@export
var close_sound : AudioStreamPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Starship and body == starship:
		(get_tree().get_first_node_in_group("World") as World).enter_abyss(destination_star_system, starship, global_rotation)
		$Openable/Area3D.set_deferred("monitoring", false)
		starship.abyssal_portal_active = false
		queue_free()

func _process(delta: float) -> void:
	tunnel_material.uv1_offset.z += offset_velocity * delta
	tunnel_material.uv1_offset.y += offset_velocity / 6 * delta
	
func close() -> void:
	if (openable.state == Openable.State.OPENING):
		await openable.openable_opened
	
	close_sound.play()
	openable.close()

func _ready() -> void:
	tunnel_material = tunnel_mesh.get_active_material(0)
	
	openable.open()
	open_sound.play()

func _on_openable_openable_closed() -> void:
	starship.abyssal_mfd.set_gateway_closed()

	await get_tree().create_timer(5).timeout
	
	queue_free()


func _on_openable_openable_opened() -> void:
	$Openable/Area3D.set_deferred("monitoring", true)
	starship.abyssal_mfd.set_gateway_open()
