extends Node3D

@export_category("Thruster Capacity")

@export
var thruster_force : float

@export
var thruster_health_points : float

@export
var thruster_fuel_consumption : float

func take_damage(damage):
	thruster_health_points -= damage
	thruster_health_points = clamp(thruster_health_points, 0, thruster_health_points)

func fire_thruster(amount):
	for p in $ParticleFX.get_children():
		p.amount_ratio = amount
