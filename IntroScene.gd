extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_current_scene(self)

#set_current_scene(value) setterget_current_scene() getter
#"res://Bestests levels/BestLevelCutscne.tscn"
var cutscene= preload("res://Bestests levels/BestLevelCutscne.tscn")
func _on_new_g_ame_pressed():
	get_tree().change_scene_to_packed(cutscene)


func _on_exit_g_ame_pressed():
	get_tree().quit()
