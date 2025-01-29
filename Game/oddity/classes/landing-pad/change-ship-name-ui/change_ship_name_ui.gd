extends Node3D

class_name ChangeShipNameUi

@export
var landing_pad : LandingPad

@export
var ship_name_label : Label3D

func _ready() -> void:
	landing_pad.starship_landed.connect(on_ship_landed)

func on_ship_landed(starship : Starship) -> void:
	ship_name_label.text = starship.ship_name

func add_letter(letter : String) -> void:
	ship_name_label.text += letter

	if landing_pad.starship != null:
		landing_pad.starship.ship_name = ship_name_label.text

func backspace() -> void:
	ship_name_label.text = ship_name_label.text.left(ship_name_label.text.length() - 1)

	if landing_pad.starship != null:
		landing_pad.starship.ship_name = ship_name_label.text


func _on_q_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_w_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_e_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_r_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_t_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_z_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_u_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_i_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_o_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_p_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_a_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_s_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_d_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_f_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_g_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_h_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_j_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_k_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_l_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_y_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_x_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_c_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_v_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_b_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_n_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_m_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.

# 1
func _on__interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_2_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_3_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_4_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_6_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_5_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_7_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_8_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_9_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_0_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_space_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.


func _on_backspace_interacted(player: Player, control_entity: ControlEntity) -> void:
	pass # Replace with function body.
