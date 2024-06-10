extends Area3D


func squash_bug():
	print("Splattered")
	get_parent().get_node("Label3D").set_visible(true)
	get_tree().call_group("level", "squash_bug",self )























