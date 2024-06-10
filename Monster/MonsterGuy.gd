extends CharacterBody3D

@onready var bloospray=preload("res://Monster/BloodSprayEnemy.tscn")
@onready var critical_bloodspray=preload("res://Monster/CriticalBloodSpray.tscn")
@onready var health=100
var current_state="idle"
var next_state="spawn"
var previous_state
@onready var player
func _ready():
	
	player=get_tree().get_first_node_in_group("player")
	#print(player)

func _physics_process(delta):
	if previous_state!=current_state:
		$StateLabel.text=current_state
	previous_state = current_state
	current_state = next_state
	
	match current_state:
		"spawn":
			spawn()
		"idle":
			idle()
		"bite":
			bite()
		"chase":
			chase(delta)
		"recoil":
			recoil(delta)
		"death":
			death()
		"spit":
			spit()

@onready var spit_projectile = preload("res://Monster/spit.tscn")
func spit():
	if previous_state!=current_state:
		var projectile = spit_projectile.instantiate()
		get_tree().get_first_node_in_group("world").add_child(projectile)
		projectile.fire()
		$Monster/AnimationPlayer.play("Spit")

@onready var ammo=load("res://Pickups/ammo_picup.tscn")
@onready var health_pickup=load("res://Pickups/health_pickup.tscn")
func drop_item():
	var rand_numn=rand.randi_range(0,2)
	if rand_numn==0:
		var a = ammo.instantiate()
		get_tree().get_first_node_in_group("level").add_child(a)
		a.position=position+Vector3(0,1,0)
	else:
		var b = health_pickup.instantiate()
		get_tree().get_first_node_in_group("level").add_child(b)
		b.position=position+Vector3(0,1,0)

func death():
	if previous_state!=current_state:
		$CollisionShape3D.disabled=true
		var rand_numn=rand.randi_range(0,9)
		if rand_numn>5:
			drop_item()
			
		if not dead:
			#print("we got to the death function")
			get_tree().call_group("level", "enemy_death")
			dead=true
		$Monster/AnimationPlayer.play("Death")

func spawn():
	$Monster/AnimationPlayer.play("Spawn")

func recoil(delta):
	velocity = -(nav.get_next_path_position() - position).normalized() * speed * delta
	move_and_collide(velocity)
	$Monster/AnimationPlayer.play("recoil")

@onready var dead=false
func take_damage(num, type, blood_pos):
	var blood
	match type:
		"critical":
			blood=critical_bloodspray.instantiate()
		"normal":
			blood=bloospray.instantiate()
	$FlinchSound.play()
	next_state="recoil"
	blood.position=blood_pos
	blood.emitting=true
	get_tree().get_first_node_in_group("level").add_child(blood)
	health-=num
	if health<=0:
		next_state="death"
		return

@onready var rand=RandomNumberGenerator.new()
@onready var nav = $NavigationAgent3D
@onready var speed = 15.0
@onready var turnspeed = 4
func chase(delta):
	$Monster/AnimationPlayer.play("FLoat")
	velocity = (nav.get_next_path_position() - position).normalized() * speed * delta
	$FaceDirection.look_at(player.position, Vector3.UP)
	rotate_y(deg_to_rad($FaceDirection.rotation.y * turnspeed))
	if  player.position.distance_to(self.position) < 4:
		next_state="bite"
	
	if  player.position.distance_to(self.position) > 1:
		nav.target_position = player.position
		move_and_collide(velocity)

func idle():
	next_state="chase"
	if previous_state!=current_state:
		$Monster/AnimationPlayer.play("Rest")

func bite():
	if previous_state!=current_state:
		$BiteSound.play()
		$Monster/AnimationPlayer.play("Bite")

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		next_state="idle"

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Spawn":
			next_state="chase"
		"Bite":
			next_state="chase"
		"recoil":
			await get_tree().create_timer(0.25).timeout
			next_state="chase"
		"Death":
			queue_free()

func _on_bite_collision_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(20)
