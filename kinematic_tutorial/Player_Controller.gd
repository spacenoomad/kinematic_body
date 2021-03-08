extends KinematicBody2D

export var jump_force = 0.0
export var _speed = 0.0
export var _gravity = 0.0
export var can_jump_start = 0

var can_jump = 0

var _velocity = Vector2()
var _floor = Vector2(0, -1)



enum {
	IDLE
	RUN
	AIR
}

var _state: int = IDLE

func _ready():
	can_jump = can_jump_start
	print(can_jump)

func _physics_process(delta):
	var my_move_direction = move_direction()
	_velocity.y += _gravity
	
	if is_on_floor():
		can_jump = can_jump_start
	
	match _state:
		IDLE:
			_velocity.x = 0
			if my_move_direction:
				change_state(RUN)
			elif Input.is_action_just_pressed("jump") and can_jump > 0:
				print("jumpin")
				_velocity.y = -jump_force
				can_jump -= 1
				change_state(AIR)
		RUN:
			if not my_move_direction:
				change_state(IDLE)
			elif Input.is_action_just_pressed("jump") and can_jump > 0:
				print("jumpin")
				_velocity.y = -jump_force
				can_jump -= 1
				change_state(AIR)
			else:
				_velocity.x = my_move_direction.x * _speed
		AIR:
			if my_move_direction:
				_velocity.x = my_move_direction.x * _speed
			else: 
				_velocity.x = 0
			
			if _velocity.y < 1:
				change_state(IDLE)
			
	_velocity = move_and_slide(_velocity, _floor)
	

func move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 0
	)

func change_state(target_state: int):
	_state = target_state
