class_name HUD
extends CanvasLayer

## HUD.gd
## Live score, coin counter, hearts display, and game over / win modal overlays.

@onready var score_label: Label = $Control/MarginContainer/HBoxContainer/ScoreLabel
@onready var coin_label: Label = $Control/MarginContainer/HBoxContainer/CoinLabel
@onready var lives_label: Label = $Control/MarginContainer/HBoxContainer/LivesLabel

@onready var win_overlay: ColorRect = $Control/WinOverlay
@onready var win_score_label: Label = $Control/WinOverlay/VBoxContainer/WinScoreLabel
@onready var restart_win_button: Button = $Control/WinOverlay/VBoxContainer/RestartWinButton

@onready var game_over_overlay: ColorRect = $Control/GameOverOverlay
@onready var retry_button: Button = $Control/GameOverOverlay/VBoxContainer/RetryButton

func _ready() -> void:
	win_overlay.visible = false
	game_over_overlay.visible = false
	
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.coins_changed.connect(_on_coins_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.level_completed.connect(_on_level_completed)
	GameManager.game_over.connect(_on_game_over)
	
	restart_win_button.pressed.connect(_on_restart_pressed)
	retry_button.pressed.connect(_on_restart_pressed)
	
	_update_all_labels()

func _update_all_labels() -> void:
	score_label.text = "SCORE: %d" % GameManager.score
	coin_label.text = "COINS: %d/%d" % [GameManager.coins, GameManager.max_level_coins]
	
	var hearts := ""
	for i in range(GameManager.lives):
		hearts += "<3 "
	lives_label.text = "LIVES: %s" % hearts

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: %d" % new_score

func _on_coins_changed(new_coins: int) -> void:
	coin_label.text = "COINS: %d/%d" % [new_coins, GameManager.max_level_coins]

func _on_lives_changed(new_lives: int) -> void:
	var hearts := ""
	for i in range(max(0, new_lives)):
		hearts += "<3 "
	lives_label.text = "LIVES: %s" % hearts

func _on_level_completed() -> void:
	win_score_label.text = "FINAL SCORE: %d" % GameManager.score
	win_overlay.visible = true
	SoundManager.play_sfx("jump", 4.0)

func _on_game_over() -> void:
	game_over_overlay.visible = true

func _on_restart_pressed() -> void:
	GameManager.reset_game()
	get_tree().reload_current_scene()
