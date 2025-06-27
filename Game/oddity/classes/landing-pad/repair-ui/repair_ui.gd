extends Node3D

class_name RepairUi

@export
var repair_ui_2d : RepairUi2d

@export
var landing_pad : LandingPad

var landed_ship : Starship

var repair_costs : int
var refuel_costs : int
var restock_costs : int

var credit_hud : CreditHud = CreditHud.new()

func _ready() -> void:
	landing_pad.starship_landed.connect(_on_ship_landed)
	landing_pad.starship_took_off.connect(_on_ship_took_off)

func calculate_repair_costs(starship : Starship) -> int:
	var health_difference : float = starship.max_hull_health - starship.current_hull_health

	return (health_difference * 1.5) as int

func calculate_refuel_costs(starship : Starship) -> int:
	return 0
	
func calculate_restock_costs(starship : Starship) -> int:
	var restock_difference : float = starship.max_ammo - starship.current_ammo
	
	return (roundf(restock_difference * 4) as int)

func _on_ship_landed(starship : Starship) -> void:
	repair_costs = calculate_repair_costs(starship)
	refuel_costs = calculate_refuel_costs(starship)
	restock_costs = calculate_restock_costs(starship)
	
	repair_ui_2d.ship_landed(starship, credit_hud.convert_to_human_readable(repair_costs))

	landed_ship = starship

func _on_ship_took_off(starship : Starship) -> void:
	landed_ship = null
	repair_ui_2d.ship_took_off()

# repair
func _on_interaction_button_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landed_ship == null:
		$Decline.play()
		return

	if landed_ship.current_hull_health == landed_ship.max_hull_health:
		$Decline.play()
		return

	if repair_costs == 0:
		$Decline.play()
		return

	if player.credits < repair_costs:
		$Decline.play()
		return

	landed_ship.repair()

	repair_ui_2d.repaired()
	
	$AudioStreamPlayer3D.play()

	player.remove_credits(repair_costs)

# refuel
func _on_interaction_button_2_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landed_ship == null:
		$Decline.play()
		return

	if refuel_costs == 0:
		$Decline.play()
		return

	if player.credits < refuel_costs:
		$Decline.play()
		return
		
# restock
func _on_interaction_button_3_interacted(player: Player, control_entity: ControlEntity) -> void:
	if landed_ship == null:
		$Decline.play()
		return

	if landed_ship.current_ammo == landed_ship.max_ammo:
		$Decline.play()
		return

	if restock_costs == 0:
		$Decline.play()
		return

	if player.credits < restock_costs:
		$Decline.play()
		return
	
		landed_ship.repair()

	repair_ui_2d.repaired()
	
	$AudioStreamPlayer3D.play()

	player.remove_credits(repair_costs)
