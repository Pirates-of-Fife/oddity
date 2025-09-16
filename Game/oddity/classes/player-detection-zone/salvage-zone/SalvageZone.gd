extends PlayerDetectionZone

class_name SalvageZone

@export
var salvage_scene_array : Array

var is_salvage_spawnable : bool 

func _ready() -> void:
	_salvage_zone_ready()

# Called when the node enters the scene tree for the first time.
func _salvage_zone_ready() -> void:
	_player_detection_zone_ready()
	
	var random : int = randi_range(0, 1)
	
	if random == 1:
		is_salvage_spawnable = true
		use_distance_display = true
	else:
		is_salvage_spawnable = false
		use_distance_display = false
		queue_free()
		
	generate_random_name()

func generate_random_name() -> void:
	var prefixes : Array = [
		"SVC", "RKW", "KST", "RBK", "DLZ", "JNX", "VLT", "OBX", "FRG", "DSX", "TSR", "GRA"
	]
	var sectors : Array = [
		"Gamma", "Delta", "Sigma", "Zeta", "Theta", "Omicron", "Epsilon",
		"Kappa", "Iota", "Lambda", "Tau", "Rho", "Xenon", "Vega", "Nyx"
	]
	var suffixes : Array= [
		"Field", "Zone", "Cluster", "Drift", "Anomaly", "Scatter", "Shell",
		"Wreckfield", "Grave", "Remnants", "Debris Cloud", "Fracture"
	]

	var id_code : String = str(randi() % 900 + 100) + "-" + str(randi() % 90 + 10)
	var prefix : String = prefixes[randi() % prefixes.size()]
	var sector : String = sectors[randi() % sectors.size()]
	var suffix : String = suffixes[randi() % suffixes.size()]
	var code : String = prefix + "-" + sector + "-" + id_code

	var label_prefix : String = "Salvage Zone "
	if randf() < 0.4:
		label_prefix = "Derelict Site "
		
	var label : String = label_prefix + code + " " + suffix

	($MarkerSprite as MarkerSprite).text = label
	

func _on_activate(player: Player, control_entity: ControlEntity) -> void:
	if !is_salvage_spawnable:
		return
	
	var salvage : Node3D = (salvage_scene_array.pick_random() as PackedScene).instantiate()
	$Salvage.add_child(salvage)

func _on_deactivate(player: Player, control_entity: ControlEntity) -> void:
	for i : Node in $Salvage.get_children():
		i.queue_free()
