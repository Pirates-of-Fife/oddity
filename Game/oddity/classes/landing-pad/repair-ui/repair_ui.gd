extends Node3D

class_name RepairUi

@export
var repair_ui_2d : RepairUi2d

@export
var landing_pad : LandingPad

var landed_ship : Starship

var repair_costs : int

var credit_hud : CreditHud = CreditHud.new()

func _ready() -> void:
	landing_pad.starship_landed.connect(_on_ship_landed)
	landing_pad.starship_took_off.connect(_on_ship_took_off)

func calculate_repair_costs(starship : Starship) -> int:
	var health_difference : float = starship.max_hull_health - starship.current_hull_health
	
	return (health_difference * 2) as int
	
	
	

func _on_ship_landed(starship : Starship) -> void:
	repair_costs = calculate_repair_costs(starship)
	
	repair_ui_2d.ship_landed(starship, credit_hud.convert_to_human_readable(repair_costs))
	
	landed_ship = starship
	print("ship landed")
	
func _on_ship_took_off(starship : Starship) -> void:
	landed_ship = null
	repair_ui_2d.ship_took_off()
	print("ship not laned")

func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	print("Repair requested")
	print(landed_ship)
	print(repair_costs)
	print(landed_ship.current_hull_health == landed_ship.max_hull_health)
	
	
	if landed_ship == null:
		return
	
	if landed_ship.current_hull_health == landed_ship.max_hull_health:
		return
	
	if repair_costs == 0:
		return
		
	if player.credits < repair_costs:
		return
		
	landed_ship.repair()
	
	repair_ui_2d.repaired()
	
	print("ship repaireds")
	
	player.remove_credits(repair_costs)
