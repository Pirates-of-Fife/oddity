extends Minable

class_name ObeliskMineable

@export
var depletion_sound : AudioStreamPlayer3D

var depleted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_obelisk_ready()
	
func _obelisk_ready() -> void:
	_mineable_ready()
	
	resource_depleted.connect(_obelisk_depleted)

func _process(delta: float) -> void:
	if depleted == true:
		position += Vector3(0, 50 * delta, 0) * global_basis.inverse()
		
		if position.y >= 1000:
			queue_free()
	

func _obelisk_depleted() -> void:
	depletion_sound.play()
	depleted = true
	print("DEPLETET")
