extends CharacterBody3D

# I wrote this script in a way that it would get the job done asap
#there are some good practices here but mostly its just quick and dirty coding 
@onready var health = 100
@onready var derringer = preload("res://Weapons/Derringer/derringer.tscn") 
@onready var damn_that_hurt = load("res://Player/DamnThat hurt.ogg")
@onready var finally = load("res://Player/Finally.ogg")
@onready var hell_yes_dude = load("res://Player/Hell yes dude.ogg")
@onready var glock_clip = load("res://Player/Its better than the pea shooter.ogg")
@onready var nice = load("res://Player/Nice.ogg")
@onready var ouch = load("res://Player/Ouch.ogg")
@onready var slow_but_reliable = load("res://Player/SlowButReiliable.ogg")
@onready var smoke_em = load("res://Player/SmokeEm.ogg")
@onready var audio=$PlayerAudio
const SPEED = 20.0
const JUMP_VELOCITY = 7.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var mouse_sensitivity_x = -0.09

func _ready():
	audio.volume_db=1
	audio.stream=smoke_em
	audio.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var starting_gun = derringer.instantiate()
	$CameraHolder/WeponHolder.add_child(starting_gun)
	starting_gun.add_inital_ammo(1,30)
	starting_gun.update_ammo()
	var derringer_offset = Vector3(0,-1.5,0)
	starting_gun.position += derringer_offset

@onready var paused= false
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * mouse_sensitivity_x))

@onready var can_interact= false

func disable_interactions():
	can_interact=false

func near_hand():
	interactable="hand"
	can_interact=true

func near_shotgun():
	interactable="shotgun"
	can_interact=true

func near_glock():
	interactable="glock"
	can_interact=true

func near_mac10():
	interactable="mac10"
	can_interact=true

func near_statue():
	interactable="statue"
	can_interact=true

@onready var ammo_up_sound = load("res://Cutscnene/reloadsound.ogg")
func ammo_up():
	audio.stream=ammo_up_sound
	audio.play()
	var holder=get_node("CameraHolder/WeponHolder")
	var weapon_list=holder.weapon_list
	var current_weapon = $CameraHolder/WeponHolder.get_child(0)
	#print("currrent_weapon: ", current_weapon.name)
	for weapons in weapon_list:
		if weapons==current_weapon.name:
			if weapons=="Mac10":
				current_weapon.ammo_in_inventory+=65
			if weapons=="Shotgun":
				current_weapon.ammo_in_inventory+=25
			if weapons=="Glock":
				current_weapon.ammo_in_inventory+=45
			if weapons=="Derringer":
				current_weapon.ammo_in_inventory+=65
		if weapons=="Mac10":
			holder.ammo_dict[weapons.to_lower()][1]+=65
		if weapons=="Shotgun":
			holder.ammo_dict[weapons.to_lower()][1]+=25
		if weapons=="Glock":
			holder.ammo_dict[weapons.to_lower()][1]+=45
		if weapons=="Derringer":
			holder.ammo_dict[weapons.to_lower()][1]+=65
	$CameraHolder/WeponHolder.get_child(0).update_ammo()

@onready var death_scene=load("res://Cutscnene/EndingScene.tscn")
func take_damage(num):
	audio.stream=ouch
	audio.play()
	health-=num
	if health<=0:
		get_tree().change_scene_to_packed(death_scene)
	update_health()

@onready var points=0
func award_points(num):
	audio.stream=hell_yes_dude
	audio.play()
	points += num
	$CameraHolder/Camera3D/PlayerUI/Pionts.text = str(points)

@onready var replenish= load("res://Outro/Replenish.ogg") 
func heal_self():
	$PlayerAudio.stream=replenish
	$PlayerAudio.play()
	health=100
	update_health()

@onready var health_label=$CameraHolder/Camera3D/PlayerUI/Health
func update_health():
	health_label.text=str(health)

@onready var interactable="none"
@onready var error_sound=load("res://Bestests levels/error.ogg")
func update_points():
	$CameraHolder/Camera3D/PlayerUI/Pionts.text=str(points)

func check_interactions():
	if can_interact:
		if Input.is_action_just_pressed("interact"):
			match interactable:
				"hand":
					get_tree().call_group("level","interact_with_hand")
				"shotgun":
					if not "Shotgun" in $CameraHolder/WeponHolder.weapon_list:
						if points>=1500:
							$CameraHolder/WeponHolder.weapon_list.append("Shotgun")
							$CameraHolder/WeponHolder.switch_to_weapon("Shotgun")
							$PlayerAudio.stream = slow_but_reliable
							$PlayerAudio.play()
							points-=1500
							update_points()
						else:
							$PlayerAudio.stream=error_sound
							$PlayerAudio.play()
					else:
						if points>=500:
							points-=500
							update_points()
							$PlayerAudio.stream = nice
							$PlayerAudio.play()
							if $CameraHolder/WeponHolder.get_child(0).name=="Shotgun":
								$CameraHolder/WeponHolder.get_child(0).ammo_in_inventory+=25
								$CameraHolder/WeponHolder.get_child(0).update_ammo()
							else:
								$CameraHolder/WeponHolder.ammo_dict["shotgun"][1]+=12
								$CameraHolder/WeponHolder.get_child(0).update_ammo()
						else:
							$PlayerAudio.stream=error_sound
							$PlayerAudio.play()
							#print("not enough cash, stranger") 
				"glock":
					if not "Glock" in $CameraHolder/WeponHolder.weapon_list:
						if points>=1200:
							$CameraHolder/WeponHolder.weapon_list.append("Glock")
							$CameraHolder/WeponHolder.switch_to_weapon("Glock")
							$PlayerAudio.stream = slow_but_reliable
							$PlayerAudio.play()
							points-=1200
							update_points()
						else:
							$PlayerAudio.stream=error_sound
							$PlayerAudio.play()
							print("not enough cash, stranger") 
					else:
						if points>=500:
							update_points()
							$PlayerAudio.stream = nice
							$PlayerAudio.play()
							if $CameraHolder/WeponHolder.get_child(0).name=="Glock":
								$CameraHolder/WeponHolder.get_child(0).ammo_in_inventory+=40
								$CameraHolder/WeponHolder.get_child(0).update_ammo()
							else:
								$CameraHolder/WeponHolder.ammo_dict["glock"][1]+=30
								$CameraHolder/WeponHolder.get_child(0).update_ammo()
							#$CameraHolder/WeponHolder.update_ammo()
						else:
							$PlayerAudio.stream=error_sound
							$PlayerAudio.play()
							print("not enough cash, stranger") 
						
				"mac10":
					if not "Mac10" in $CameraHolder/WeponHolder.weapon_list:
						if points>=2500:
							$CameraHolder/WeponHolder.weapon_list.append("Mac10")
							$CameraHolder/WeponHolder.switch_to_weapon("Mac10")
							$PlayerAudio.stream = slow_but_reliable
							$PlayerAudio.play()
							points-=2500
							update_points()
					else:
						if points>=500:
							points-=500
							update_points()
							$PlayerAudio.stream = nice
							$PlayerAudio.play()
							if $CameraHolder/WeponHolder.get_child(0).name=="Mac10":
								$CameraHolder/WeponHolder.get_child(0).ammo_in_inventory+=60
								$CameraHolder/WeponHolder.get_child(0).update_ammo()
							else:
								$CameraHolder/WeponHolder.ammo_dict["mac10"][1]+=60
								$CameraHolder/WeponHolder.get_child(0).update_ammo()
							#$CameraHolder/WeponHolder.update_ammo()
						else:
							$PlayerAudio.stream=error_sound
							$PlayerAudio.play()
							print("not enough cash, stranger") 

				"none":
					pass
	else:
		return

func _physics_process(delta):
	check_interactions()
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_pressed("ui_accept")and is_on_floor():
		velocity.y=JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	#print(input_dir)

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	print(direction)
#vector3(0,0,0)= 0 = false
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func update_player_sounds_volume(val):
	$PlayerAudio.volume_db=val

func update_y_sensitivity(val):
	print("updated in the player script: ", val)
	mouse_sensitivity_x = val








#it is not a good idea to drink coffee with asprin every morning. 
