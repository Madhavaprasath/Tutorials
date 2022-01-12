extends KinematicBody2D


var velocity=Vector2()
var speed=250
enum State{Moving,Recording}
enum Moving{IDLE,MOVING,JUMPING,FALL}
var moving_state=Moving.IDLE
var current_state=State.Moving
var direction_vector=Vector2()
var recorded_data
onready var rewind=get_node("Reverse_Time")

func _physics_process(delta):
	if(current_state!=State.Recording):
		var s=match_states()
		if s!=null:
			moving_state=s
			animation(moving_state)
		apply_gravity(delta)
		apply_movement(delta)
		velocity=move_and_slide(velocity,Vector2(0,-1))
		rewind.update_info([position,$Body.scale.x,rotation,$Body/icon.frame])
	else:
		$Body/AnimationPlayer.stop(true)
		if(recorded_data!=null):
			var record_position=recorded_data[0]
			var record_facing=recorded_data[1]
			var record_rotation=recorded_data[2]
			var record_frame=recorded_data[3]
			if(record_position!=null):
				global_position=record_position
			if(record_rotation!=null):
				rotation=record_rotation
			if(record_frame!=null):
				$Body/icon.frame=record_frame
			if(record_facing!=null):
				$Body.scale.x=record_facing

func apply_gravity(delta):
	velocity.y+=1000*delta

func apply_movement(delta):
	var direction={"Left":int(Input.is_action_pressed("ui_left")),
		"Right":int(Input.is_action_pressed("ui_right"))}
	direction_vector.x=direction["Right"]-direction["Left"]
	velocity.x=lerp(velocity.x,direction_vector.x*speed,0.8)
	if(direction_vector.x!=0):
		$Body.scale.x=direction_vector.x

func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_pressed("ui_up"):
		velocity.y=-500

func match_states():
	match moving_state:
		Moving.IDLE:
			if is_on_floor():
				if direction_vector.x!=0:
					return Moving.MOVING
				elif velocity.y<0:
					return Moving.JUMPING
			elif !is_on_floor():
				if velocity.y>0:
					return Moving.FALL
		Moving.MOVING:
			if is_on_floor():
				if direction_vector.x==0:
					return Moving.IDLE
				elif velocity.y<0:
					return Moving.JUMPING
			elif !is_on_floor():
				if velocity.y>0:
					return Moving.FALL
		Moving.JUMPING:
			if velocity.y>0:
				return Moving.FALL
		Moving.FALL:
			if is_on_floor():
				return Moving.IDLE
	return null


func animation(state):
	var anim=""
	match state:
		Moving.IDLE:
			anim="Idle"
		Moving.MOVING:
			anim="Moving"
		Moving.FALL:
			anim="Fall"
		Moving.JUMPING:
			anim="Jump"
	if($Body/AnimationPlayer.current_animation!=anim):
		$Body/AnimationPlayer.play(anim)
func get_recorded_data(arr):
	recorded_data=arr
