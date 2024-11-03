extends Node3D

@export
var x_offset : float
@export
var y_offset : float

@onready
var crosshairSprite :Sprite3D = $crosshairUI1stPerson

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
 # Calculate the distance from the center (0,0) to the current position
	var distance : float = Vector2(x_offset, y_offset).length()

	# Map the distance to a scale value between 30% and 100%
	var scale : float = lerp(1.0, 0.3, distance / 100)
	
	scale = clamp(scale, 0.3, 1.0);

	crosshairSprite.scale = Vector3(scale, scale, scale)
	
	crosshairSprite.offset.x = x_offset / scale
	crosshairSprite.offset.y = y_offset / scale
