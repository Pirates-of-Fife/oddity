extends StaticBody3D

var count : int = 0

func _ready() -> void:
	$Label3D.text = str(count)

func _on_interactable_interacted(player : Player, control_entity : ControlEntity) -> void:
	count += 1
	$Label3D.text = str(count)
	$AnimationPlayer.play("splosh")
