extends Node3D

class_name ChangeShipNameUi

@export
var landing_pad : LandingPad

@export
var ship_name_label : Label3D

func _ready() -> void:
	landing_pad.starship_landed.connect(on_ship_landed)
	landing_pad.starship_took_off.connect(on_ship_took_off)
	ship_name_label.text = "No ship"

func on_ship_landed(starship : Starship) -> void:
	ship_name_label.text = starship.ship_name
	
func on_ship_took_off(starship : Starship) -> void:
	ship_name_label.text = "No ship"

func add_letter(letter : String) -> void:
	ship_name_label.text += letter
	
	$Click.play()

	if landing_pad.starship != null:
		landing_pad.starship.ship_name = ship_name_label.text

func backspace() -> void:
	
	$Remove.play()
	
	if ship_name_label.text.length() <= 0:
		return
	
	ship_name_label.text = ship_name_label.text.left(ship_name_label.text.length() - 1)

	if landing_pad.starship != null:
		landing_pad.starship.ship_name = ship_name_label.text

func _on_q_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("Q")

func _on_w_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("W")

func _on_e_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("E")

func _on_r_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("R")

func _on_t_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("T")

func _on_z_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("Z")

func _on_u_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("U")

func _on_i_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("I")

func _on_o_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("O")

func _on_p_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("P")

func _on_a_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("A")

func _on_s_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("S")

func _on_d_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("D")

func _on_f_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("F")

func _on_g_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("G")

func _on_h_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("H")

func _on_j_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("J")

func _on_k_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("K")

func _on_l_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("L")

func _on_y_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("Y")

func _on_x_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("X")

func _on_c_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("C")

func _on_v_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("V")

func _on_b_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("B")

func _on_n_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("N")

func _on_m_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("M")

func _on_backspace_interacted(player: Player, control_entity: ControlEntity) -> void:
	backspace()

func _on__interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("1")

func _on_2_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("2")

func _on_3_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("3")

func _on_4_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("4")

func _on_5_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("5")

func _on_6_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("6")

func _on_7_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("7")

func _on_8_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("8")

func _on_9_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("9")

func _on_0_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter("0")


func _on_space_interacted(player: Player, control_entity: ControlEntity) -> void:
	add_letter(" ")
