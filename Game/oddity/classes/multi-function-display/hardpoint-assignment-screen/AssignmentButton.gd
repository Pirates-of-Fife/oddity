extends Node3D

class_name AssignmentButtons

@export
var hardpoint : Hardpoint

@export
var current_selection : Hardpoint.HardpointAssignment

@export
var default_color : Color

@export
var selected_color : Color

func set_ready() -> void:
	current_selection = hardpoint.assignment
	match current_selection:
		Hardpoint.HardpointAssignment.PRIMARY:
			($InteractionButton1/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = selected_color
			($InteractionButton2/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
			($InteractionButton3/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
		Hardpoint.HardpointAssignment.SECONDARY:
			($InteractionButton1/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
			($InteractionButton2/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = selected_color
			($InteractionButton3/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
		Hardpoint.HardpointAssignment.TERTIARY:
			($InteractionButton1/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
			($InteractionButton2/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
			($InteractionButton3/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = selected_color
			
func _on_interaction_button_1_interacted(player: Player, control_entity: ControlEntity) -> void:
	hardpoint.assignment = Hardpoint.HardpointAssignment.PRIMARY
	($InteractionButton1/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = selected_color
	($InteractionButton2/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
	($InteractionButton3/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color


func _on_interaction_button_2_interacted(player: Player, control_entity: ControlEntity) -> void:
	hardpoint.assignment = Hardpoint.HardpointAssignment.SECONDARY
	($InteractionButton1/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
	($InteractionButton2/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = selected_color
	($InteractionButton3/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color

func _on_interaction_button_3_interacted(player: Player, control_entity: ControlEntity) -> void:
	hardpoint.assignment = Hardpoint.HardpointAssignment.TERTIARY
	($InteractionButton1/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
	($InteractionButton2/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = default_color
	($InteractionButton3/MeshInstance3D.get_active_material(0) as StandardMaterial3D).albedo_color = selected_color
