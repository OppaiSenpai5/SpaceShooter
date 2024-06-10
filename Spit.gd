extends Node3D

func _ready():
	set_as_top_level(true)

func fire():
	var player=get_tree().get_first_node_in_group("player")
	print(player)
	var last_point = player.position
	var starting_point= position 
	var middle_positon= ((starting_point + last_point) / 2 )# + Vector3(0,5,0)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", last_point, 1).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "position", last_point, 10).set_trans(Tween.TRANS_SINE)
	tween.connect("finished",kill_self)

func kill_self():
	queue_free()

func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(5)
	queue_free()
