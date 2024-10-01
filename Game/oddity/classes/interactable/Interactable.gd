extends StaticBody3D

class_name Interactable

signal interacted

func interact() -> void:
	interacted.emit()
	
