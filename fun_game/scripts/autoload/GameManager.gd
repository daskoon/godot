extends Node

## GameManager.gd
## State authority for score, coins, lives, and level progression.

signal score_changed(new_score: int)
signal coins_changed(new_coins: int)
signal lives_changed(new_lives: int)
signal game_over()
signal level_completed()

var score: int = 0
var coins: int = 0
var lives: int = 3
var max_level_coins: int = 8

func reset_game() -> void:
	score = 0
	coins = 0
	lives = 3
	score_changed.emit(score)
	coins_changed.emit(coins)
	lives_changed.emit(lives)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func collect_coin() -> void:
	coins += 1
	add_score(100)
	coins_changed.emit(coins)
	SoundManager.play_sfx("coin")
	
	if coins >= max_level_coins:
		level_completed.emit()

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	SoundManager.play_sfx("jump", -6.0)
	if lives <= 0:
		game_over.emit()
