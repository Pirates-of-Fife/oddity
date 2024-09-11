extends Node3D

var total_shield_output : float

var current_shield_output : float

# Called when the node enters the scene tree for the first time.
func _ready():
	total_shield_output = count_total_shield_output()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_shield_output = count_current_shield_output()

func count_total_shield_output() -> float:
	var shield : float
	
	for shield_generator in get_children():
		shield += shield_generator.total_shield_output
	
	return shield

func count_current_shield_output() -> float:
	var shield : float
	
	for shield_generator in get_children():
		shield += shield_generator.current_shield_output
	
	return shield
	
