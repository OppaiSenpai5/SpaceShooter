extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_exit_game_pressed():
	get_tree().quit()

@onready var Startscene=preload("res://Bestests levels/Intro.tscn")
func _on_replay_pressed():
	get_tree().change_scene_to_packed(Startscene)

func _on_view_video_pressed():
	OS.shell_open("https://youtu.be/CiuwgMTsU20?si=R8l-xI73QoIlQfMJ")
