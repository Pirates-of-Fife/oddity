@tool
class_name Test2
extends MeshInstance3D

var ship : RigidBody3D

func _ready():
	ship = get_parent_node_3d().get_node("ShipBody")

func _process(delta):
	ship = get_parent_node_3d().get_node("ShipBody")
	scale = Vector3(ship.mass, ship.mass, ship.mass)
