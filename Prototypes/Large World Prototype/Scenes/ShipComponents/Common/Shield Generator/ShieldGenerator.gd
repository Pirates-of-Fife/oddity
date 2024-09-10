extends "res://Scenes/Spaceship/Common/Interfaces/I_PoweredComponent.gd"

@export_category("Manufacturer Information")

@export
var manufacturer : String

@export
var model : String

@export_category("Component Information")

@export_range(0, 10, 1)
var size_class : int

@export
var total_shield_output : float

@export
var heat_per_shield_charge : float

@export
var ambient_shield_heat : float

@export
var power_per_shield_charge : float

@export
var ambient_shield_power_usage : float

@export_category("Structural Information")

@export
var health_points : float

@export
var integrity : float

var current_shield_output : float
var current_power_output : float
var current_heat : float
var wear : float

# Called when the node enters the scene tree for the first time.
func _ready():
	power_priority = 1

func recieve_power(power : float):
	recieved_power = power

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
