extends CharacterBody2D

@export var speed: float = 160.0
@export var jump_velocity: float = -250.0
@export var gravity: float = 980.0
var stat = "walk"

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handel_jump()
	handle_horizontal_movement(delta)
	move_and_slide()
	if Input.is_action_just_pressed("Run") and is_on_floor():
		speed = 300.0
		stat = "run"
	elif Input.is_action_just_released("Run"):
		speed = 10.0
		stat = "walk"
	
func apply_gravity(delta: float) -> void:
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0

func handel_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity 
		animated_sprite.play("jump")

func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed
		animated_sprite.play(stat)
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 5)
		animated_sprite.play("idle")
