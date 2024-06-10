extends Node3D

@onready var mouse_sensitivity_y = -0.04
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(deg_to_rad(event.relative.y * mouse_sensitivity_y))

func update_boss_health(health):
	$Camera3D/PlayerUI/BossHealth.value=health

func update_ammo(numlist):
	#print(numlist)
	$Camera3D/PlayerUI/inventoryAmmo.text=str(numlist[1])
	$Camera3D/PlayerUI/Ammo.text=str(numlist[0])

func show_boss_health():
	$Camera3D/PlayerUI/BossHealth.visible=true

func update_y_sensitivity(val):
	print("updated in the cam script: ", val)
	mouse_sensitivity_y = val
