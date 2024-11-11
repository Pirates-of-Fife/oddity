extends Node

class_name RaycastHelper

#========================================================================#
# Casts a raycast into the local negative z direction of the origin node #
#========================================================================#
func cast_raycast_from_node(origin_node : Node3D, length : float) -> Dictionary:
		var space_state : PhysicsDirectSpaceState3D = origin_node.get_world_3d().direct_space_state
		
		var origin : Vector3 = origin_node.global_position
		var end : Vector3 = origin_node.global_position + Vector3(0, 0, -length) * origin_node.global_basis.inverse()
		
		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end, 536870912)
		
		var result : Dictionary = space_state.intersect_ray(query)
		
		return result
		
func cast_downwards_raycast(origin_node : Node3D, length : float, ignore : Node3D, collision_layers : int) -> Dictionary:
		var space_state : PhysicsDirectSpaceState3D = origin_node.get_world_3d().direct_space_state
		
		var origin : Vector3 = origin_node.global_position
		var end : Vector3 = origin_node.global_position + Vector3(0, -length, 0) * origin_node.global_basis.inverse()
		
		var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end, collision_layers, [ignore])
				
		var result : Dictionary = space_state.intersect_ray(query)
				
		return result
