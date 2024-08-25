extends "res://Scenes/Spaceship/Common/Interfaces/I_PoweredComponent.gd"

@export_category("Manufacturer Information")

@export
var manufacturer : String

@export
var model : String

@export_category("Component Information")

@export_range(0, 10, 1)
var size_class : int

@export_category("Structural Information")

@export
var health_points : float

@export
var integrity : float

var wear : float

# Called when the node enters the scene tree for the first time.
func _ready():
	power_priority = 5

func recieve_power(power : float):
	recieved_power = power

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
