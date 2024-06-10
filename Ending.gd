extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed():
	$Button.disabled=true
	get_tree().change_scene_to_file("res://Bestests levels/Intro.tscn")
	#get_tree().reload_current_scene()
