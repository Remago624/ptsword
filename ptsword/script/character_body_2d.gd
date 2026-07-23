extends CharacterBody2D

@export var speed: float = 160.0
@export var jump_velocity: float = -250.0
@export var gravity: float = 980.0
const IDLE = "idle"
const WALK = "walk"
const RUN = "run"
const JUMP = "jump"
const FALL = "falling"
const SWING = "swing"
var anime_state
var state = "walk"

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handel_jump()
	handle_horizontal_movement(delta)
	move_and_slide()
	update_animation()
	if Input.is_action_just_pressed("Run") and is_on_floor():
		speed = 220.0
		state = "run"
	elif Input.is_action_just_released("Run"):
		speed = 160.0
		state = "walk"
	
func apply_gravity(delta: float) -> void:
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0

func handel_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity 

func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 5)
func update_animation() -> void:
	var direction := Input.get_axis("move_left","move_right")
	#if animated_sprite.animation == "swing" and animated_sprite.is_playing():
		#return
	if !is_on_floor():
		if velocity.y < 0:
			set_animation(JUMP)
		else:
			set_animation(FALL)
	elif direction:
		animated_sprite.play(state)
	else:
		set_animation(IDLE)
	if Input.is_action_just_pressed("swing"):
		set_animation(SWING)
func set_animation(anim: String):
	if anime_state != anim:
		anime_state = anim
		animated_sprite.play(anim)
