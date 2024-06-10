extends Control

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused=false
			paused=false
			visible=false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			paused=true
			visible=true
			get_tree().paused=true

@onready var paused = false
func _on_button_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCREf5gBgyx7QASKsG_5dYEw")

func _on_button_2_pressed():
	get_tree().quit()


func _on_mouse_y_slider_drag_ended(value_changed):
	var val = $Settings/VBoxContainer/Mouse_Y_Slider.value
	print("Mouse_Y: ", val)
	get_tree().call_group("level", "update_Y_sensitivity", val)


func _on_mouse_x_slider_drag_ended(value_changed):
	var val = $Settings/VBoxContainer/Mouse_X_Slider.value
	print("Mouse_X: ", val)
	get_tree().call_group("level", "update_X_sensitivity", val)


func _on_music_slider_drag_ended(value_changed):
	var val = $Settings/VBoxContainer/Music_Slider.value
	get_tree().call_group("level", "update_music", val)
	print("Music_Slider: ", val)


func _on_h_slider_drag_ended(value_changed):
	var val = $Settings/VBoxContainer/HSlider.value
	get_tree().call_group("player", "update_player_sounds_volume", val)
	print("HSlider: ", val)
