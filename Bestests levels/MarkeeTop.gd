extends MeshInstance3D



@onready var pic_a=load("res://Bestests levels/Kiosk_LizardA.png")
@onready var pic_b=load("res://Bestests levels/Occulttwo.jpg")
@onready var pic_c=load("res://Picture/Metokur.jpg")
@onready var pic_d=load("res://Picture/Willy2Guns Death (VOD) - YouTube - Google Chrome 1_20_2024 3_25_32 PM.png")
@onready var pic_e=load("res://Picture/logog.png")
@onready var pic_f=load("res://Picture/Hunter-pipe-eyes.png")
@onready var pic_g=load("res://Picture/ThePotatoe.png")
@onready var pic_h=load("res://Picture/Rotateshapes.jpg")


@onready var mat_A = mesh.surface_get_material(0)
@onready var mat_B = mesh.surface_get_material(1)
@onready var mat_C = mesh.surface_get_material(2)



@onready var num = 0
func _on_timer_timeout():
	num+=1
	if num>3:
		num=0
		
	match num:
		0:
			mat_A.albedo_texture = pic_a
			mat_B.albedo_texture = pic_b
			mat_C.albedo_texture = pic_c
		1:
			mat_A.albedo_texture = pic_d
			mat_B.albedo_texture = pic_e
			mat_C.albedo_texture = pic_f
		2:
			mat_A.albedo_texture = pic_g
			mat_B.albedo_texture = pic_h
			mat_C.albedo_texture = pic_f
