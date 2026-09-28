class_name PatrolEnemy
extends CharacterBody2D

## PatrolEnemy.gd
## Enemy that patrols platforms. Can be stomped from above or hurts player from side.

@export var speed: float = 120.0
@export var patrol_distance: float = 140.0

var direction: float = 1.0
var start_x: float = 0.0

@onready var visual: Node2D = $Visual
@onready var hit_area: Area2D = $HitArea

func _ready() -> void:
	start_x = global_position.x
	if hit_area:
		hit_area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	velocity.y += 980.0 * delta
	
	if abs(global_position.x - start_x) > patrol_distance or is_on_wall():
		direction *= -1.0
		start_x = global_position.x
		
	if visual:
		visual.scale.x = -1.0 if direction < 0 else 1.0
		
	move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Check if player is falling onto enemy (stomp)
		if body.velocity.y > 0 and body.global_position.y < global_position.y - 10:
			body.velocity.y = -400.0 # Stomp bounce
			GameManager.add_score(200)
			SoundManager.play_sfx("coin", 2.0)
			queue_free()
		else:
			if body.has_method("take_damage"):
				body.call("take_damage")
