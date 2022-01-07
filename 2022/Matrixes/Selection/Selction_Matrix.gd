extends Matrix

var characterstic_matrix
var names=["U-2 spy plane","B-52 Stratofortress","F-16 Fighting Falcon","MiG-21 fighter",
"Tupolev Tu-95 bomber","Bf 109 fighter","P-51 Mustang","Dassault-Breguet Mirage","Mitsubishi Zero",
"A-10 Thunderbolt II"]
var type=["Bullet","Missile","Missile and Bullet"]
var about_type=["Bullet Plane",
"Missile Plane",
"Missile and Bullet Plane"]
var current_position=0
onready var display_nodes=get_tree().get_nodes_in_group("Display")



func _ready():
	var name_index=0
	var type_index=0
	var frame=0
	characterstic_matrix=initalize_total_value_matrix(6,len(names),0)
	for i in range(len(characterstic_matrix)):
		for j in range(len(characterstic_matrix[0])):
			if(i==0):
				characterstic_matrix[i][j]=names[name_index]
				name_index+=1
			elif(i==1):
				type_index+=1
				if(type_index>=3):
					type_index=0
				characterstic_matrix[i][j]=type[type_index]
				
			elif(i==2):
				var value
				match(characterstic_matrix[1][j]):
					"Bullet":
						value=[100,75,about_type[0],frame]
						
					"Missile and Bullet":
						value=[25,25,about_type[2],frame]
					"Missile":
						value=[50,50,about_type[1],frame]
				frame+=1
				for k in range(len(value)):
					characterstic_matrix[i+k][j]=value[k]
	print_matrix(characterstic_matrix)
	change_value()

func change_value(pos=0):
	for i in range(len(display_nodes)):
		var current_label=display_nodes[i]
		if(current_label is Label):
			current_label.text=str(characterstic_matrix[i][pos])
		else:
			current_label.frame=characterstic_matrix[i][pos]

func save_model():
	var elements=[]
	for i in range(len(display_nodes)):
		var current_node=display_nodes[i]
		if(current_node is Label):
			elements.append(current_node.text)
		else:
			elements.append(current_node.frame)
	write_data(elements)

func write_data(elements):
	var save_file=File.new()
	save_file.open("user://save_file.save",File.WRITE)
	var data={}
	for i in range(len(elements)):
		data[i]=elements[i]
	save_file.store_line(to_json(data))
	save_file.close()


func _on_Button_pressed():
	current_position+=1
	if(current_position>len(characterstic_matrix[1][0])):
		current_position=0
	change_value(current_position)


func Load_model():
	var save_file=File.new()
	if not save_file.file_exists("user://save_file.save"):
		printerr("No file found")
		return
	save_file.open("user://save_file.save",File.READ)
	var data=parse_json(save_file.get_line())
	var display_nodes=get_tree().get_nodes_in_group("Display")
	for i in range(len(display_nodes)):
		var current_node=display_nodes[i]
		if current_node is Label:
			current_node.text=str(data[str(i)])
		else:
			current_node.frame=int(data[str(i)])
