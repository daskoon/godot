class_name PlatformCoin
extends Area2D

## PlatformCoin.gd
## Golden collectible coin for platformer level score & progress.

@onready var visual: Node2D = $Visual

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if visual:
		visual.position.y = sin(Time.get_ticks_msec() * 0.006) * 4.0
		visual.rotation += delta * 2.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.collect_coin()
		_spawn_floating_popup("+100", global_position)
		queue_free()

func _spawn_floating_popup(text_str: String, pos: Vector2) -> void:
	var label = Label.new()
	label.text = text_str
	label.global_position = pos + Vector2(-15, -20)
	label.modulate = Color(1.0, 0.9, 0.2)
	label.add_theme_font_size_override("font_size", 16)
	get_parent().add_child(label)
	
	var tween = label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position", label.position + Vector2(0, -35), 0.5)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.chain().tween_callback(label.queue_free)
