extends Node3D

class_name TradeItemInformationScreen

# this should be loaded only when the terminal turns on

@export
var current_trade_item : TradeResource

@export
var preview : Node3D

@export_flags_3d_render
var visibility_layers : int

var currently_spawned_trade_item : GameEntity

@export
var rotation_speed : float = 4

@export
var camera : Camera3D

@export
var title : Label3D

@export
var credits : TradeCreditLabel

@export
var description : Label3D

@export
var stats : Label3D

func display_trade_item(trade_item : TradeResource, station_markup : float) -> void:
	if currently_spawned_trade_item != null:
		currently_spawned_trade_item.queue_free()
	
	credits.show()
	
	current_trade_item = trade_item
	
	spawn_trade_item()
	
	title.text = current_trade_item.name
	description.text = current_trade_item.description
	credits.credits = current_trade_item.value * station_markup

func spawn_trade_item() -> void:
	var trade_item_scene : PackedScene = load(current_trade_item.scene)
	var trade_item : GameEntity = trade_item_scene.instantiate()
	
	preview.add_child(trade_item)
	
	trade_item.save = false	
	trade_item.remove_from_group("GameEntity")
	
	trade_item.owner = get_tree().edited_scene_root
	
	camera.position.z = current_trade_item.preview_distance
		
	currently_spawned_trade_item = trade_item
	
	stats.text = generate_stats(trade_item)
	
func generate_stats(game_entity : GameEntity) -> String:
	if game_entity is ShieldGenerator:
		var info : ShieldGeneratorResource = (game_entity as ShieldGenerator).module_resource
		var text : String = ""
		
		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Max Shield Health: " + str(snappedf(info.max_shield_health, 0.01)) + "\n"
		text += "Time to Charge: " + str(snappedf(info.max_shield_health / (info.charge_rate * info.charge_time), 0.01)) + "\n"
		text += "Heat Generation: " + str(snappedf(info.shield_heat_per_charge / info.charge_rate, 0.01)) + "\n"
		text += "Heat on Recharge: " + str(snappedf(info.shield_heat_per_full_recharge, 0.01)) + "\n"
		text += "Hit Cooldown: " + str(snappedf(info.cooldown_time_after_hit, 0.01)) + " s\n"
		text += "Break Cooldown: " + str(snappedf(info.cooldown_time_after_break, 0.01)) + "s"
		
		return text
	
	if game_entity is HullReinforcement:
		var info : HullReinforcementResource = (game_entity as HullReinforcement).module_resource
		var text : String = ""
		
		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Additional Hull Health: " + str(snappedf(info.additional_hull_health, 0.01)) + "\n"
		text += "Additional Armour Health: " + str(snappedf(info.additional_armour_health, 0.01)) + "\n"
		text += "Additional Armour Rating: " + str(snappedf(info.additional_armour_rating, 0.01))
		
		return text
		
	if game_entity is Cooler:
		var info : CoolerResource = (game_entity as Cooler).module_resource
		var text : String = ""
		
		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Heat Sink Capacity: " + str(snappedf(info.heat_sink_size, 0.01)) + "\n"
		text += "Cooling per Second: " + str(snappedf(info.cooling_capacity / info.cooling_interval, 0.01))

		return text
	
	if game_entity is PowerPlant:
		return ""
	
	if game_entity is ProjectileWeapon:
		var info : ProjectileWeaponResource = (game_entity as ProjectileWeapon).module_resource
		var text : String = ""

		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Hull Damage: " + str(roundf(info.hull_damage)) + "\n"
		text += "Shield Damage: " + str(roundf(info.shield_damage)) + "\n"
		text += "Projectile Speed: " + str(roundf(info.projectile_speed)) + "m/s\n"
		text += "Penetration: " + str(roundf(info.penetration)) + "\n"
		text += "Fire Rate: " + str(snappedf(1 / info.cooldown, 0.01)) + "\n"
		text += "Ammo per Second: " + str(snappedf(info.ammo_usage * (1 / info.cooldown), 0.01)) + "\n"
		text += "Heat per Second: " + str(snappedf(info.heat_per_shot * (1 / info.cooldown), 0.01)) + "\n"
		text += "Ammo per Shot: " + str(snappedf(info.ammo_usage, 0.01)) + "\n"
		text += "Heat per Shot: " + str(roundf(info.heat_per_shot))
		
		if game_entity is ScatterWeapon:
			var scatter_info : ScatterGunResource = (game_entity as ScatterWeapon).module_resource
			
			text += "\n"
			text += "Secondary Hull Damage: " + str(roundf(scatter_info.secondary_projectile_damage * 32)) + "\n"
			text += "Secondary Shield Damage: " + str(roundf(scatter_info.secondary_projectile_shield_damage * 32)) + "\n"
			text += "Secondary Penetration: " + str(roundf(scatter_info.secondary_projetile_penetration)) + "\n"
			text += "Scatter Delay: " + str(snappedf(scatter_info.scatter_time, 0.01))
		
		return text

	if game_entity is MiningLaser:
		var info : MiningLaserResource = (game_entity as MiningLaser).module_resource
		var text : String = ""

		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Hull Damage: " + str(roundf(info.hull_damage)) + "\n"
		text += "Shield Damage: " + str(roundf(info.shield_damage)) + "\n"
		text += "Penetration: " + str(roundf(info.penetration)) + "\n"
		text += "Max Distance: " + str(roundf(info.max_beam_length)) + "\n"
		text += "Heat Generation: " + str(roundf(info.heat_generation)) + "\n"
		text += "Mining Efficiency: " + str(roundf(info.mining_efficiency))
		
		return text
		
	if game_entity is PulseLaserWeapon:
		var info : PulseLaserWeaponResource = (game_entity as PulseLaserWeapon).module_resource
		var text : String = ""

		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Hull DPS: " + str(roundf(info.hull_damage * info.fire_time * 100 * (1 / (info.fire_time + info.cooldown)))) + "\n"
		text += "Shield DPS: " +  str(roundf(info.shield_damage * info.fire_time * 100 * (1 / (info.fire_time + info.cooldown)))) + "\n"
		text += "Penetration: " + str(roundf(info.penetration)) + "\n"
		text += "Max Distance: " + str(roundf(info.max_beam_length)) + "\n"
		text += "Heat Generation: " + str(roundf(info.heat_generation)) + "\n"
		text += "Pulse Time: " + str(snappedf(info.fire_time, 0.01)) + " s\n"
		text += "Cooldown: " + str(snappedf(info.cooldown, 0.01)) + " s\n"
	
		return text

	if game_entity is BeamWeapon:
		var info : BeamWeaponResource = (game_entity as BeamWeapon).module_resource
		var text : String = ""

		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Hull DPS: " + str(roundf(info.hull_damage)) + "\n"
		text += "Shield DPS: " + str(roundf(info.shield_damage)) + "\n"
		text += "Hull Damage: " + str(roundf(info.hull_damage)) + "\n"
		text += "Shield Damage: " + str(roundf(info.shield_damage)) + "\n"
		text += "Penetration: " + str(roundf(info.penetration)) + "\n"
		text += "Max Distance: " + str(roundf(info.max_beam_length)) + "\n"
		text += "Heat Generation: " + str(roundf(info.heat_generation)) + "\n"
		
		return text
		
	if game_entity is AlcubierreDrive:
		var info : AlcubierreDriveResource = (game_entity as AlcubierreDrive).module_resource
		var text : String = ""

		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Spool Time: " + str(roundf(info.spool_time)) + " s\n"
		text += "Max Speed: " + str(snappedf(info.max_speed / 299_792_458 * 1000, 0.01)) + " C\n"
		text += "Accelleration: " + str(snappedf(info.acceleration, 0.1)) + "\n"
		text += "Deaccelleration: " + str(snappedf(info.deacceleration, 0.1)) + "\n"
		text += "Turn Speed: " + str(snappedf(info.max_turn_speed, 0.01)) + "\n"
		text += "Fuel per Second: " + str(snappedf(info.fuel_per_second, 0.01))
		
		return text
		
	if game_entity is AbyssalJumpDrive:
		var info : AbyssalJumpDriveResource = (game_entity as AbyssalJumpDrive).module_resource
		var text : String = ""

		text += "Power Usage: " + str(snappedf(info.power_usage, 0.01)) + "MW\n"
		text += "Jump Range: " + str(roundf(info.jump_range)) + " LY\n"
		text += "Fuel Usage (max): " + str(snappedf(info.fuel_usage_modifier.sample(1) * info.fuel_per_ly, 0.1)) + "\n"
		text += "Fuel Usage (75%): " + str(snappedf(info.fuel_usage_modifier.sample(0.75) * info.fuel_per_ly, 0.1)) + "\n"
		text += "Fuel Usage (50%): " + str(snappedf(info.fuel_usage_modifier.sample(0.5) * info.fuel_per_ly, 0.1)) + "\n"
		text += "Fuel Usage (25%): " + str(snappedf(info.fuel_usage_modifier.sample(0.25) * info.fuel_per_ly, 0.1)) + "\n"
		text += "Fuel Usage (10%): " + str(snappedf(info.fuel_usage_modifier.sample(0.1) * info.fuel_per_ly, 0.1))

		
		return text
	
	return ""
