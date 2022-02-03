extends HBoxContainer



func _ready():
	for i in get_tree().get_nodes_in_group("recordables"):
		i.connect("is_rewinding",self,"rewind")



func rewind(is_rewinding):
	if(is_rewinding):
		visible=true
	else:
		visible=false
