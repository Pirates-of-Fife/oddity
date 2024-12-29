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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Starship and body == starship:
		(get_tree().get_first_node_in_group("World") as World).enter_abyss(destination_star_system, starship, global_rotation)
		print("THIS SHOULD ONLY APPEAR ONCE " + str(self) + " " + str(body))
		$Openable/Area3D.set_deferred("monitoring", false)
		starship.abyssal_portal_active = false
		queue_free()

func _process(delta: float) -> void:
	tunnel_material.uv1_offset.z += offset_velocity * delta
	tunnel_material.uv1_offset.y += offset_velocity / 6 * delta
	
func close() -> void:
	openable.close()
	

func _ready() -> void:
	tunnel_material = tunnel_mesh.get_active_material(0)
	
	openable.open()


func _on_openable_openable_closed() -> void:
	queue_free()
	starship.abyssal_mfd.set_gateway_closed()


func _on_openable_openable_opened() -> void:
	$Openable/Area3D.set_deferred("monitoring", true)
	starship.abyssal_mfd.set_gateway_open()
