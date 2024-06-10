extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var level=preload("res://Bestests levels/BestLevelA.tscn")

func _on_cutscene_driver_animation_finished(anim_name):
	get_tree().change_scene_to_packed(level)


func _on_button_pressed():
	get_tree().change_scene_to_packed(level)
