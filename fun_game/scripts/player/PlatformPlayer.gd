class_name PlatformPlayer
extends CharacterBody2D

## PlatformPlayer.gd
## Ultra-responsive 2D platformer player controller.
## Built-in input handling for WASD, Arrow keys, and Space with 0 setup required.

@export var move_speed: float = 340.0
@export var jump_velocity: float = -660.0
@export var gravity: float = 1300.0

@onready var visual: Node2D = $BodyVisual

var can_double_jump: bool = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_dead: bool = false
var spawn_position: Vector2

func _ready() -> void:
	add_to_group("player")
	spawn_position = global_position

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		coyote_timer = 0.15
		can_double_jump = true

	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

	# Check jump input (Space, W, Up Arrow, ui_accept, ui_up)
	var jump_pressed = Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up") or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	if jump_pressed:
		jump_buffer_timer = 0.15

	# Execute jump
	if jump_buffer_timer > 0.0:
		if coyote_timer > 0.0:
			_execute_jump(jump_velocity)
			coyote_timer = 0.0
			jump_buffer_timer = 0.0
		elif can_double_jump and not is_on_floor():
			_execute_jump(jump_velocity * 0.88)
			can_double_jump = false
			jump_buffer_timer = 0.0

	# Variable jump height
	var jump_released = Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_up")
	if jump_released and velocity.y < 0:
		velocity.y *= 0.45

	# Calculate horizontal direction
	var direction := 0.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT) or Input.is_action_pressed("ui_right"):
		direction += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) or Input.is_action_pressed("ui_left"):
		direction -= 1.0

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * move_speed, 2400.0 * delta)
		if visual:
			visual.scale.x = -1.0 if direction < 0 else 1.0
			var bob = sin(Time.get_ticks_msec() * 0.02) * 0.12
			visual.scale.y = 1.0 - bob
	else:
		velocity.x = move_toward(velocity.x, 0, 2800.0 * delta)
		if visual and is_on_floor():
			visual.scale = visual.scale.lerp(Vector2.ONE, 0.2)

	move_and_slide()
	
	if global_position.y > 600:
		take_damage()

func _execute_jump(vel_y: float) -> void:
	velocity.y = vel_y
	SoundManager.play_sfx("jump")
	if visual:
		visual.scale = Vector2(0.65, 1.45)

func take_damage() -> void:
	if is_dead:
		return
	is_dead = true
	GameManager.lose_life()
	
	velocity = Vector2(0, -320.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.2, 0.5)
	tween.finished.connect(func():
		global_position = spawn_position
		velocity = Vector2.ZERO
		modulate.a = 1.0
		is_dead = false
	)
