extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("Idle")


func _on_animation_finished(anim_name):
	play("Idle")
