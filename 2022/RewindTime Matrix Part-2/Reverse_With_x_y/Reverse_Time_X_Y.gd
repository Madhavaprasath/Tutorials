extends Matrix
class_name Rewind
enum states{rewind,recording}
export(int)var maximum_seconds=20
var time_gap=1
var maximum_times=60*20
var time_matrix=[]
var already_pressed=false
export(int)var segments=4
var  total_times=0
var index=0

onready var parent=get_parent()

"""Stores the value of position in one row,Rotation in other 
	 Facing value ,Destroyed or Not ting This is Based on matrixes for 
	"""

export(int)var rows=2
export(int) var colums=2
func _ready() -> void:
	set_physics_process(false)
	time_matrix=initalize_total_value_matrix(rows,colums,[])

func update_info(arr:Array):
	var count=0
	for i in range(rows):
		for j in range(colums):
			var current_array=time_matrix[i][j]
			if(len(current_array)>maximum_times):
				current_array.pop_back()
			current_array.insert(0,arr[count])
			count+=1

func _physics_process(delta: float) -> void:
	var tot=[]
	for i in range(rows):
		for j in range(colums):
			var current_array=time_matrix[i][j]
			var ele=current_array.pop_front()
			tot.append(ele)
	parent.get_recorded_data(tot)
func _unhandled_input(event: InputEvent) -> void:
	if(total_times<segments):
		if(event.is_action_pressed("ui_accept")&&!already_pressed):
			parent.current_state=parent.State.Recording
			set_physics_process(true)
			already_pressed=true
			$Timer.start(maximum_seconds/segments)
			total_times+=1



func _on_Timer_timeout() -> void:
	set_physics_process(false)
	already_pressed=false
