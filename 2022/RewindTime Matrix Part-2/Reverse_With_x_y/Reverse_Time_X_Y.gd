extends Matrix
class_name Rewind

signal is_rewinding(rewind)

var fps=Performance.get_monitor(Performance.TIME_FPS)
enum states{rewind,recording}
export(int)var maximum_seconds=20
var time_gap=1
var maximum_times=30*20
var time_matrix=[]
var already_pressed=false
export(int)var segments=4
var  total_times=0
var index=0
var first_time_values=[]

onready var parent=get_parent()

"""Stores the value of position in one row,Rotation in other 
	 Facing value ,Destroyed or Not ting This is Based on matrixes for 
	"""

export(int)var rows=5
export(int) var colums=1
func _ready() -> void:
	set_physics_process(false)
	time_matrix=initalize_total_value_matrix(rows,colums,[])

func update_info(arr:Array):
	print(Performance.get_monitor(Performance.TIME_FPS))
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
	var is_everything_null=false
	for i in range(rows):
		for j in range(colums):
			var current_array=time_matrix[i][j]
			var ele=current_array.pop_front()
			tot.append(ele)
	for i in range(0,len(tot)-1):
		if(tot[i]==null && tot[i+1]==null):
			is_everything_null=true
	if(!is_everything_null):
		rewind_data(tot)
	else:
		set_physics_process(false)
		already_pressed=false
func _unhandled_input(event: InputEvent) -> void:
	if(total_times<segments):
		if(event.is_action_pressed("ui_accept")&&!already_pressed):
			if(total_times==0):
				for i in range(rows):
					for j in range(colums):
						first_time_values.append(time_matrix[i][j][0])
			parent.current_state=parent.State.Recording
			parent.emit_signal("is_rewinding",true)
			set_physics_process(true)
			already_pressed=true
			$Timer.start(maximum_seconds/segments)
			total_times+=1
	if(event.is_action_pressed("ui_cancel")&&!already_pressed&&total_times>0&&first_time_values!=[]):
		parent.emit_signal("is_rewinding",false)
		rewind_data(first_time_values)
		parent.animation(parent.moving_state,false)
		first_time_values=[]
		parent.current_state=parent.State.Moving
	if(event.is_action_pressed("Space")&&!already_pressed&&total_times>0):
		parent.emit_signal("is_rewinding",false)
		parent.animation(parent.moving_state,false)
		parent.current_state=parent.State.Moving


func _on_Timer_timeout() -> void:
	set_physics_process(false)
	already_pressed=false

func rewind_data(tot):
	var recorded_values=tot
	if(recorded_values[0]!=null):
		parent.position=recorded_values[0]
	if (recorded_values[1]!=null):
		parent.body.scale.x=recorded_values[1]
	if(recorded_values[2]!=null):
		parent.rotation=recorded_values[2]
	if(recorded_values[3]!=null):
		parent.sprite.frame=recorded_values[3]
	if(recorded_values[4]!=null):
		parent.moving_state=recorded_values[4]

