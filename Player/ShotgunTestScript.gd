extends MeshInstance3D


@onready var active_gun= true
@onready var canfire = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active_gun:
		if Input.is_action_just_pressed("fire") and canfire:
			canfire=false
			fire()
			
func fire():
	print("we have fired")
	
