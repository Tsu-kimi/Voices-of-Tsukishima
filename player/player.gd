extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY = 1000
@export var speed: int = 1000
@export var max_horizontal_speed = 300
@export var jump: int = -300
@export var jump_horizontal_speed : int = 1000
@export var max_jump_horizontal_speed = 300
@export var slow_down_speed : int = 1700

enum State { Idle, Run, Jump } # Added Jump state

var current_state : State

var character_sprite : Sprite2D


func _ready():
	current_state = State.Idle


func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	Player_run(delta)
	Player_jump(delta) # Added jump function call

	move_and_slide()

	Player_animation()
	
	print("State: ", State.keys()[current_state])


func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func player_idle(delta : float):
	if is_on_floor():
		current_state = State.Idle


func Player_run(delta : float):
	var direction = input_movement()

	if direction:
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)

	if direction != 0 and is_on_floor():
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func Player_jump(delta : float):
	if Input.is_action_just_pressed("Jump"):
		velocity.y = jump
		current_state  = State.Jump

	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed , max_jump_horizontal_speed )
		animated_sprite_2d.flip_h = false if direction > 0 else true if direction != 0 else animated_sprite_2d.flip_h


func Player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
		
func input_movement():
	var direction :  float =  Input.get_axis("Move_Left", "Move_Right")
	
	return direction
