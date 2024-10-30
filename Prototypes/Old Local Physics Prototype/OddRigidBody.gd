extends RigidBody3D

class_name OddRigidBody

var applied_force : Vector3
var applied_torque : Vector3

var physics_parent : Node3D

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if physics_parent:
		state.transform.origin += physics_parent.linear_velocity * state.step
				
		var rotation_axis = physics_parent.global_basis
		var rotation_angle = physics_parent.angular_velocity.length() * state.step
		
		var local_pos = state.transform.origin - physics_parent.global_transform.origin
		local_pos = local_pos.rotated(rotation_axis.get_euler(), rotation_angle)
		state.transform.origin = physics_parent.global_transform.origin + local_pos
		
		state.transform.basis = state.transform.basis.rotated(rotation_axis.get_euler(), rotation_angle)
		
	state.linear_velocity += applied_force * state.step
	state.angular_velocity += applied_torque * state.step
