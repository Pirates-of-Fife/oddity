extends Node3D

const MainScene : String  = "res://Scenes/Main Scene/Main.tscn"


func _on_join_button_pressed():
	get_tree().change_scene_to_file(MainScene)
