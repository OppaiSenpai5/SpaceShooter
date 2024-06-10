extends Node3D


@onready var in_between_waves=true
func _ready():
	$InBetweenWaves.start()
	rand.randomize()

func update_wave_timer(val):
	print("we are updating the wave timer: ", val)
	$InBetweenWaves.wait_time=val

func update_music(val):
	print("updating Music in level: ", val)
	$AudioStreamPlayer.volume_db=val
	$AudioStreamPlayer2.volume_db=val
	
func update_Y_sensitivity(val):
	print("We are have the Y value in the level script: ", val)
	get_tree().call_group("player", "update_y_sensitivity", val)
	
func update_X_sensitivity(val):
	print("We are have the X value in the level script: ", val)
	get_tree().call_group("Cam", "update_y_sensitivity", val)


@onready var bug_list=[]
func squash_bug(bug):
	#print(bug_list)
	if not bug in bug_list:
		bug_list.append(bug)
		
	if len(bug_list)>=6:
		$AudioStreamPlayer2.play()
		#print("bugs dead")

@onready var ui_timer=get_tree().get_nodes_in_group("player")[0].get_node("CameraHolder/Camera3D/PlayerUI/TimerLabel")
@onready var dead_enemies=0
func flip_in_boss():
	in_boss=true
#we will flip this after we finish level 5
@onready var in_boss=false
func enemy_death():

	if not in_boss:
		dead_enemies+=1
		#print("amount of dead enemies: ", dead_enemies)
		#print("current_level: ", current_level)
		if dead_enemies==monster_dict[current_level]:
			$InBetweenWaves.start()
			dead_enemies=0
		if current_level>=6:
			#print("this has ran the boss is summoned")
			in_boss=true
			get_tree().call_group("boss","wakeup")
	get_tree().call_group("player", "award_points", 200)

func _process(delta):
	if in_between_waves:
		ui_timer.text=str($InBetweenWaves.get_time_left())
	else:
		pass

@onready var current_level=0
@onready var monster_dict={
	1:8,
	2:14,
	3:25,
	4:30,
	5:35
}
@onready var monster= preload("res://Monster/MonsterGuy.tscn")
@onready var rand=RandomNumberGenerator.new()

func spawn_boss_wave():
	for i in range(4):
		var m = monster.instantiate()
		var spawn_length = $MonsterSpawn.get_child_count()-1
		var rand_num = rand.randi_range(0,spawn_length)
		var spawn_postion = $MonsterSpawn.get_child(rand_num).position
		add_child(m)
		m.position = spawn_postion
		
		await get_tree().create_timer(2.0).timeout
		#print("amount of monsters: ",i+1)

func spawn_enemies():
	for i in range(monster_dict[current_level]):
		var m = monster.instantiate()
		var spawn_length = $MonsterSpawn.get_child_count()-1
		var rand_num = rand.randi_range(0,spawn_length)
		var spawn_postion = $MonsterSpawn.get_child(rand_num).position
		add_child(m)
		m.position = spawn_postion
		
		await get_tree().create_timer(2.0).timeout
		#print("amount of monsters: ",i+1)

func update_level(level):
	match level:
		1:
			$TheHand/AnimationPlayer.play("One")
			$TheHandSign/HandAudio.stream=audio_clip_one
		2:
			$TheHand/AnimationPlayer.play("Two")
			$TheHandSign/HandAudio.stream=audio_clip_two
		3:
			$TheHand/AnimationPlayer.play("Three")
			$TheHandSign/HandAudio.stream=audio_clip_three
		4:
			$TheHand/AnimationPlayer.play("Four")
			$TheHandSign/HandAudio.stream=audio_clip_four
		5:
			$TheHand/AnimationPlayer.play("Five")
			$TheHandSign/HandAudio.stream=audio_clip_five
	$TheHandSign/HandAudio.play()
	spawn_enemies()

@onready var audio_clip_annoyed = load("res://TheHand/Sto Pestering.ogg")
@onready var audio_clip_anoyed2 = load("res://TheHand/Leave the hand alone.ogg")
@onready var audio_clip_intro = load("res://TheHand/The hand will display the level.ogg")
@onready var audio_clip_one = load("res://TheHand/lv1.ogg")
@onready var audio_clip_two = load("res://TheHand/lv2.ogg")
@onready var audio_clip_three = load("res://TheHand/lv3.ogg")
@onready var audio_clip_four = load("res://TheHand/lv4.ogg")
@onready var audio_clip_five = load("res://TheHand/This is the finallv.ogg")
@onready var already_clicked=false
func interact_with_hand():
	match current_level:
		1:
			$TheHand/AnimationPlayer.play("One")
			$TheHandSign/HandAudio.stream=audio_clip_one
		2:
			$TheHand/AnimationPlayer.play("Two")
			$TheHandSign/HandAudio.stream=audio_clip_two
		3:
			$TheHand/AnimationPlayer.play("Three")
			$TheHandSign/HandAudio.stream=audio_clip_three
		4:
			$TheHand/AnimationPlayer.play("Four")
			$TheHandSign/HandAudio.stream=audio_clip_four
		5:
			$TheHand/AnimationPlayer.play("Five")
			$TheHandSign/HandAudio.stream=audio_clip_five
	$TheHandSign/HandAudio.play()

	#if the player gets near the hand we allow or disallow logic.

func _on_hand_area_body_entered(body):
	if body.is_in_group("player"):
		$TheHand/Label3D.visible = true
		body.near_hand()

func _on_hand_area_body_exited(body):
	if body.is_in_group("player"):
		$TheHand/Label3D.visible = false
		body.disable_interactions()

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"One":
			$TheHand/AnimationPlayer.play("Thumbs up")
		"Two":
			$TheHand/AnimationPlayer.play("Thumbs up")
		"Three":
			$TheHand/AnimationPlayer.play("Thumbs up")
		"Four":
			$TheHand/AnimationPlayer.play("Thumbs up")
		"Five":
			$TheHand/AnimationPlayer.play("Thumbs up")
		"Thumbs up":
			$TheHand/AnimationPlayer.play("Idle")

func _on_in_between_waves_timeout():
	#print("Leaving level: ", current_level)
	current_level+=1
	if current_level<=5:
		update_level(current_level)
	if current_level==6:
		in_boss=true
		get_tree().call_group("boss","wakeup")
	#print("Entering level: ", current_level)

@onready var gameover= preload("res://Cutscnene/EndingScene.tscn")
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_packed(gameover)

@onready var acousticKillstream_intro = load("res://Music/JustSong.ogg")
@onready var killstream_intro = load("res://Music/KillstreamMetalSong.ogg")
@onready var ramarama = load("res://Picture/RammRAmm.ogg")

@onready var radio_clip_one = load("res://Cutscnene/HumbleHatMerchant.ogg")
@onready var radio_clip_two = load("res://Cutscnene/RAlphsWarning2.ogg")
@onready var radio_clip_three = load("res://Cutscnene/KinoCasino2.ogg")
@onready var tracknum= 0




func _on_audio_stream_player_finished():
	if $AudioStreamPlayer2.playing==false:
		match tracknum:
			1:
				$AudioStreamPlayer.volume_db=2
				$AudioStreamPlayer.stream=radio_clip_one
			2:
				$AudioStreamPlayer.volume_db=-12
				$AudioStreamPlayer.stream=ramarama
			3:
				$AudioStreamPlayer.volume_db=2
				$AudioStreamPlayer.stream=radio_clip_two
			4:
				$AudioStreamPlayer.volume_db=-12
				$AudioStreamPlayer.stream=killstream_intro
			5: 
				$AudioStreamPlayer.volume_db=2
				$AudioStreamPlayer.stream=radio_clip_three
			6:
				$AudioStreamPlayer.volume_db=-12
				$AudioStreamPlayer.stream=acousticKillstream_intro
		
		$AudioStreamPlayer.play()
		tracknum+=1



func _on_audio_stream_player_2_finished():
	$AudioStreamPlayer.play()
		
