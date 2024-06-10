extends CharacterBody3D

var current_state="idle"
var next_state="idle"
var previous_state

func _physics_process(delta):
	previous_state = current_state
	current_state = next_state
	
	match current_state:
		"idle":
			idle()
		"chase":
			chase()
		"bite":
			bite()
		
func idle():
	print("we are idle")
	if Input.is_action_just_pressed("a"):
		next_state="chase"
	
func chase():
	print("we are chasing")
	if Input.is_action_just_pressed("a"):
		next_state="idle"
	#all our movement code would be here
	
func bite():
	print("we are biting")
