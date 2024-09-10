extends Node3D

var total_cooling_output : float

var current_cooling_output : float

# Called when the node enters the scene tree for the first time.
func _ready():
	total_cooling_output = count_total_cooling_output()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_cooling_output = count_current_cooling_output()

func count_total_cooling_output() -> float:
	var cooling : float
	
	for cooler in get_children():
		cooling += cooler.total_cooling_output
	
	return cooling

func count_current_cooling_output() -> float:
	var cooling : float
	
	for cooler in get_children():
		cooling += cooler.current_cooling_output
	
	return cooling
	
