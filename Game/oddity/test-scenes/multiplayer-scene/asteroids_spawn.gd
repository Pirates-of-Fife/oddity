@tool

extends Node3D

class_name AsteroidsSpawn

@export
var asteroid_1 : PackedScene

@export
var asteroid_2 : PackedScene

@export
var asteroid_3 : PackedScene

@export
var asteroid_4 : PackedScene

@export
var asteroid_5 : PackedScene

# add toggle for tool script

var asteroids : Array = Array() # Array of packed scenes

func _ready() -> void:
	asteroids.append(asteroid_1)
	asteroids.append(asteroid_2)
	asteroids.append(asteroid_3)
	asteroids.append(asteroid_4)
	asteroids.append(asteroid_5)

func generate_asteroids() -> void:
	
	# clear previous asteroids
	
	pass
