extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY = 1000
const SPEED = 300

enum State { Idle, Run}
var current_state

func _ready():
	current_state = State.Idle


func _physics_process(delta):
	player_falling(delta)
	player_idle(delta)
	Player_run(delta)

	move_and_slide()

	Player_animation()


func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta


func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle
		print("State: ", State.keys()[current_state])


func Player_run(delta):
	var direction = Input.get_axis("Move_Left","Move_Right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		current_state = State.Run
		print("State: ", State.keys()[current_state])
		animated_sprite_2d.flip_h = false if direction > 0 else true

func Player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
		

