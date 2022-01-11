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
"""Stores the value of position in one row,Rotation in other 
	 Facing value ,Destroyed or Not ting This is Based on matrixes for 
	
"""
func _ready() -> void:
	set_physics_process(false)
	time_matrix=initalize_total_value_matrix(2,2,[])
func updateposition(pos):
	var positions_arr=time_matrix[0][0]
	if(len(positions_arr)>maximum_times):
		positions_arr.pop_back() 
	positions_arr.insert(0,pos)

func _physics_process(delta: float) -> void:
	var a
	a=time_matrix[0][0].pop_front()
func _unhandled_input(event: InputEvent) -> void:
	if(total_times<segments):
		if(event.is_action_pressed("ui_accept")&&!already_pressed):
			set_physics_process(true)
			already_pressed=true
			$Timer.start(maximum_seconds/segments)
			total_times+=1



func _on_Timer_timeout() -> void:
	set_physics_process(false)
	already_pressed=false
