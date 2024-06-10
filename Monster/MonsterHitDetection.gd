extends Area3D

func take_damage(num,type,pos):
	print("here")
	get_parent().get_parent().take_damage(num,type,pos)
	
