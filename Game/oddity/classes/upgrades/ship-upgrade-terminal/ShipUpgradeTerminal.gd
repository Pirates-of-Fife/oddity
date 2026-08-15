extends StaticGameEntity

class_name ShipUpgradeTerminal

@export_category("Landing Pad")
@export
var landing_pad : LandingPad

var starship : Starship

@export_category("Upgrades")

@export
var health_upgrade_ui : UpgradeUI

@export
var health_upgrade_name : String

@export
var health_upgrade_description : String

@export
var fuel_upgrade_ui : UpgradeUI

@export
var fuel_upgrade_name : String

@export
var fuel_upgrade_description : String

@export
var ammo_upgrade_ui : UpgradeUI

@export
var ammo_upgrade_name : String

@export
var ammo_upgrade_description : String

@export
var heat_upgrade_ui : UpgradeUI

@export
var heat_upgrade_name : String

@export
var heat_upgrade_description : String

@export
var turning_upgrade_ui : UpgradeUI

@export
var turning_upgrade_name : String

@export
var turning_upgrade_description : String

@export
var thrust_upgrade_ui : UpgradeUI

@export
var thrust_upgrade_name : String

@export
var thrust_upgrade_description : String

@export
var tractor_beam_upgrade_ui : TractorBeamUpgradeUI

@export_category("UI")

@export
var title_label : Label3D

@export
var ship_name_label : Label3D

@export
var ship_id_label : Label3D

@export
var ship_outline_sprite : Sprite3D

var player : Player

func _ready() -> void:
	landing_pad.starship_landed.connect(_on_ship_landed)
	landing_pad.starship_took_off.connect(_on_ship_take_off)
	
	player = get_tree().get_first_node_in_group("Player")
	
func _on_ship_landed(ship : Starship) -> void:
	starship = ship
		
	ship_name_label.show()
	ship_name_label.text = starship.ship_name
	
	ship_id_label.show()
	ship_id_label.text = starship.ship_identification
	
	title_label.show()
	ship_outline_sprite.show()
	
	set_up_health()
	set_up_ammo()
	set_up_fuel()
	set_up_heat()
	set_up_thrust()
	set_up_turning()
	set_up_tractor()
	
func _on_ship_take_off(ship : Starship) -> void:
	starship = null
	
	ship_name_label.hide()
	ship_id_label.hide()
	title_label.hide()
	ship_outline_sprite.hide()
	
	set_down_health()
	set_down_ammo()
	set_down_fuel()
	set_down_heat()
	set_down_thrust()
	set_down_turning()
	set_down_tractor()

func set_up_health() -> void:
	health_upgrade_ui.show()
	health_upgrade_ui.upgrade.connect(_on_health_upgrade)
	health_upgrade_ui.max_upgrade_level = ShipUpgrades.MAX_UPGRADE
	health_upgrade_ui.upgrade_name = health_upgrade_name
	health_upgrade_ui.upgrade_description = health_upgrade_description
	
	update_health()

func update_health() -> void:
	health_upgrade_ui.current_upgrade_level = starship.current_health_upgrade
	health_upgrade_ui.upgrade_current_multiplier = ShipUpgrades.ship_health_upgrade[starship.current_health_upgrade]
	
	if starship.current_health_upgrade < ShipUpgrades.MAX_UPGRADE:
		health_upgrade_ui.upgrade_next_multiplier = ShipUpgrades.ship_health_upgrade[starship.current_health_upgrade + 1]
		health_upgrade_ui.upgrade_price = ShipUpgrades.ship_health_upgrade_price[starship.current_health_upgrade + 1]
	
	if starship.current_health_upgrade == ShipUpgrades.MAX_UPGRADE:
		health_upgrade_ui.max_upgrade_reached = true

func set_down_health() -> void:
	health_upgrade_ui.hide()
	health_upgrade_ui.upgrade.disconnect(_on_health_upgrade)
	
func _on_health_upgrade() -> void:
	player.remove_credits(ShipUpgrades.ship_health_upgrade_price[starship.current_health_upgrade + 1])
	starship.upgrade_health()
	update_health()

func set_up_ammo() -> void:
	ammo_upgrade_ui.show()
	ammo_upgrade_ui.upgrade.connect(_on_ammo_upgrade)
	ammo_upgrade_ui.max_upgrade_level = ShipUpgrades.MAX_UPGRADE
	ammo_upgrade_ui.upgrade_name = ammo_upgrade_name
	ammo_upgrade_ui.upgrade_description = ammo_upgrade_description
	
	update_ammo()
	
func update_ammo() -> void:
	ammo_upgrade_ui.current_upgrade_level = starship.current_ammo_capacity_upgrade
	ammo_upgrade_ui.upgrade_current_multiplier = ShipUpgrades.ship_ammo_capacity_upgrade[starship.current_ammo_capacity_upgrade]
	
	if starship.current_ammo_capacity_upgrade < ShipUpgrades.MAX_UPGRADE:
		ammo_upgrade_ui.upgrade_next_multiplier = ShipUpgrades.ship_ammo_capacity_upgrade[starship.current_ammo_capacity_upgrade + 1]
		ammo_upgrade_ui.upgrade_price = ShipUpgrades.ship_ammo_capacity_upgrade_price[starship.current_ammo_capacity_upgrade + 1]
	
	if starship.current_ammo_capacity_upgrade == ShipUpgrades.MAX_UPGRADE:
		ammo_upgrade_ui.max_upgrade_reached = true
		
func _on_ammo_upgrade() -> void:
	player.remove_credits(ShipUpgrades.ship_ammo_capacity_upgrade_price[starship.current_ammo_capacity_upgrade + 1])
	starship.upgrade_ammo()
	update_ammo()
	
func set_down_ammo() -> void:
	ammo_upgrade_ui.hide()
	ammo_upgrade_ui.upgrade.disconnect(_on_ammo_upgrade)

func set_up_heat() -> void:
	heat_upgrade_ui.show()
	heat_upgrade_ui.upgrade.connect(_on_heat_upgrade)
	heat_upgrade_ui.max_upgrade_level = ShipUpgrades.MAX_UPGRADE
	heat_upgrade_ui.upgrade_name = heat_upgrade_name
	heat_upgrade_ui.upgrade_description = heat_upgrade_description
	
	update_heat()
	
func update_heat() -> void:
	heat_upgrade_ui.current_upgrade_level = starship.current_heat_capacity_upgrade
	heat_upgrade_ui.upgrade_current_multiplier = ShipUpgrades.ship_heat_capacity_upgrade[starship.current_heat_capacity_upgrade]
	
	if starship.current_heat_capacity_upgrade < ShipUpgrades.MAX_UPGRADE:
		heat_upgrade_ui.upgrade_next_multiplier = ShipUpgrades.ship_heat_capacity_upgrade[starship.current_heat_capacity_upgrade + 1]
		heat_upgrade_ui.upgrade_price = ShipUpgrades.ship_heat_capacity_upgrade_price[starship.current_heat_capacity_upgrade + 1]
	
	if starship.current_heat_capacity_upgrade == ShipUpgrades.MAX_UPGRADE:
		heat_upgrade_ui.max_upgrade_reached = true
		
func _on_heat_upgrade() -> void:
	player.remove_credits(ShipUpgrades.ship_heat_capacity_upgrade_price[starship.current_heat_capacity_upgrade + 1])
	starship.upgrade_heat()
	update_heat()
	
func set_down_heat() -> void:
	heat_upgrade_ui.hide()
	heat_upgrade_ui.upgrade.disconnect(_on_heat_upgrade)
		
func set_up_fuel() -> void:
	fuel_upgrade_ui.show()
	fuel_upgrade_ui.upgrade.connect(_on_fuel_upgrade)
	fuel_upgrade_ui.max_upgrade_level = ShipUpgrades.MAX_UPGRADE
	fuel_upgrade_ui.upgrade_name = fuel_upgrade_name
	fuel_upgrade_ui.upgrade_description = fuel_upgrade_description
	
	update_fuel()
	
func update_fuel() -> void:
	fuel_upgrade_ui.current_upgrade_level = starship.current_fuel_capacity_upgrade
	fuel_upgrade_ui.upgrade_current_multiplier = ShipUpgrades.ship_fuel_capacity_upgrade[starship.current_fuel_capacity_upgrade]
	
	if starship.current_fuel_capacity_upgrade < ShipUpgrades.MAX_UPGRADE:
		fuel_upgrade_ui.upgrade_next_multiplier = ShipUpgrades.ship_fuel_capacity_upgrade[starship.current_fuel_capacity_upgrade + 1]
		fuel_upgrade_ui.upgrade_price = ShipUpgrades.ship_fuel_capacity_upgrade_price[starship.current_fuel_capacity_upgrade + 1]
	
	if starship.current_fuel_capacity_upgrade == ShipUpgrades.MAX_UPGRADE:
		fuel_upgrade_ui.max_upgrade_reached = true
		
func _on_fuel_upgrade() -> void:
	player.remove_credits(ShipUpgrades.ship_fuel_capacity_upgrade_price[starship.current_fuel_capacity_upgrade + 1])
	starship.upgrade_fuel()
	update_fuel()
	
func set_down_fuel() -> void:
	fuel_upgrade_ui.hide()
	fuel_upgrade_ui.upgrade.disconnect(_on_fuel_upgrade)


func set_up_turning() -> void:
	turning_upgrade_ui.show()
	turning_upgrade_ui.upgrade.connect(_on_turning_upgrade)
	turning_upgrade_ui.max_upgrade_level = ShipUpgrades.MAX_UPGRADE
	turning_upgrade_ui.upgrade_name = turning_upgrade_name
	turning_upgrade_ui.upgrade_description = turning_upgrade_description
	
	update_turning()
		
func update_turning() -> void:
	turning_upgrade_ui.current_upgrade_level = starship.current_turning_upgrade
	turning_upgrade_ui.upgrade_current_multiplier = ShipUpgrades.ship_turning_upgrade[starship.current_turning_upgrade]
	
	if starship.current_turning_upgrade < ShipUpgrades.MAX_UPGRADE:
		turning_upgrade_ui.upgrade_next_multiplier = ShipUpgrades.ship_turning_upgrade[starship.current_turning_upgrade + 1]
		turning_upgrade_ui.upgrade_price = ShipUpgrades.ship_turning_upgrade_price[starship.current_turning_upgrade + 1]
	
	if starship.current_turning_upgrade == ShipUpgrades.MAX_UPGRADE:
		turning_upgrade_ui.max_upgrade_reached = true
			
func _on_turning_upgrade() -> void:
	player.remove_credits(ShipUpgrades.ship_turning_upgrade_price[starship.current_turning_upgrade + 1])
	starship.upgrade_turning()
	update_turning()
	
func set_down_turning() -> void:
	turning_upgrade_ui.hide()
	turning_upgrade_ui.upgrade.disconnect(_on_turning_upgrade)
	
func set_up_thrust() -> void:
	thrust_upgrade_ui.show()
	thrust_upgrade_ui.upgrade.connect(_on_thrust_upgrade)
	thrust_upgrade_ui.max_upgrade_level = ShipUpgrades.MAX_UPGRADE
	thrust_upgrade_ui.upgrade_name = thrust_upgrade_name
	thrust_upgrade_ui.upgrade_description = thrust_upgrade_description
	
	update_thrust()
		
func update_thrust() -> void:
	thrust_upgrade_ui.current_upgrade_level = starship.current_thruster_upgrade
	thrust_upgrade_ui.upgrade_current_multiplier = ShipUpgrades.ship_thruster_upgrade[starship.current_thruster_upgrade]
	
	if starship.current_thruster_upgrade < ShipUpgrades.MAX_UPGRADE:
		thrust_upgrade_ui.upgrade_next_multiplier = ShipUpgrades.ship_thruster_upgrade[starship.current_thruster_upgrade + 1]
		thrust_upgrade_ui.upgrade_price = ShipUpgrades.ship_thruster_upgrade_price[starship.current_thruster_upgrade + 1]
	
	if starship.current_thruster_upgrade == ShipUpgrades.MAX_UPGRADE:
		thrust_upgrade_ui.max_upgrade_reached = true
	
func _on_thrust_upgrade() -> void:
	player.remove_credits(ShipUpgrades.ship_thruster_upgrade_price[starship.current_thruster_upgrade + 1])
	starship.upgrade_thruster()
	update_thrust()	
	
func set_down_thrust() -> void:
	thrust_upgrade_ui.hide()
	thrust_upgrade_ui.upgrade.disconnect(_on_thrust_upgrade)

func set_up_tractor() -> void:
	if !starship.supports_tractor_beam_upgrade:
		return
	
	tractor_beam_upgrade_ui.show()
	tractor_beam_upgrade_ui.tractor_beam_upgraded.connect(_on_tractor_upgrade)

func _on_tractor_upgrade() -> void:
	starship.enable_tractor_beam_upgrade()
	starship.tractor_beams_upgraded = true
	
func set_down_tractor() -> void:
	tractor_beam_upgrade_ui.hide()
	tractor_beam_upgrade_ui.tractor_beam_upgraded.disconnect(_on_tractor_upgrade)