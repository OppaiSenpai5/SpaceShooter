extends Node3D

func _ready():
	visible=false

@onready var sound=$AudioStreamPlayer3D
@onready var alive=false
@onready var current_state=""
@onready var previous_state=""
@onready var next_state="idle"
func _process(delta):
	previous_state=current_state
	current_state=next_state
	
	if alive:
		match current_state:
			"summon":
				summon()
			"appear":
				appear()
			"die":
				die()
			"fire":
				fire()
			"idle":
				idle()
			"none":
				pass
	else:	
		pass

func idle():
	if current_state!=previous_state:
		$AudioStreamPlayer3D.stream = yellB
		$AudioStreamPlayer3D.play()
		$Boss/AnimationPlayer.play("Idle")

@onready var boss_health=5000
@onready var critical_bloodspray = preload("res://Monster/CriticalBloodSpray.tscn")
func take_damage(num,type,pos):
	#print("we have been hit bossman!!!!!!!!!!!")
	boss_health-=num
	get_tree().call_group("Cam","update_boss_health",boss_health)
	if boss_health<=0:
		next_state="die"
		return
	var blood=critical_bloodspray.instantiate()
	next_state="recoil"
	blood.position=pos
	blood.emitting=true
	get_tree().get_first_node_in_group("level").add_child(blood)

func appear():
	if previous_state!=current_state:
		$Boss/AnimationPlayer.play("Openning")
		sound.play()

@onready var spitA = load("res://Picture/Large Monster Grunt Hit 01.wav")
@onready var spitB = load("res://Picture/Large Monster Grunt Hit 02.wav")
@onready var yellA = load("res://Picture/Large Monster Death 02.wav")
@onready var yellB = load("res://Picture/Large Monster Death 01.wav")

func die():
	if current_state!=previous_state:
		$Boss/AnimationPlayer.play("Die")

func wakeup():
	alive=true
	visible=true
	next_state="appear"
	get_tree().call_group("Cam","show_boss_health")

func fire():
	if current_state!=previous_state:
		$AudioStreamPlayer3D.stream = spitA
		$AudioStreamPlayer3D.play()
		$Boss/AnimationPlayer.play("Shoot")

@onready var bolt = load("res://Monster/spit.tscn")
func fire_bolt():
	var spit=bolt.instantiate()
	$Boss/Armature/Skeleton3D/BoneAttachment3D3.add_child(spit)
	spit.fire()

func summon():
	if current_state!=previous_state:
		$AudioStreamPlayer3D.stream = yellB
		$AudioStreamPlayer3D.play()
		$Boss/AnimationPlayer.play("Summon")
		get_tree().call_group("level","spawn_boss_wave")

@onready var random= RandomNumberGenerator.new()
func random_attack():
	var rand =random.randi_range(0,3)
	#print("here: ", rand)
	match rand:
		0:
			next_state="fire"
		1:
			next_state="summon"
		2:
			next_state="fire"
		3:
			next_state="summon"

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Idle":
			random_attack()
		"Die":
			get_tree().change_scene_to_file("res://Outro/outro.tscn")
		"Openning":
			next_state="idle"
		"Shoot":
			next_state="idle"
		"Summon":
			next_state="idle"
