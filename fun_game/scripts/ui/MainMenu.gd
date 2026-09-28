extends Control

## MainMenu.gd
## Main Menu interface script.

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	SoundManager.play_sfx("coin")
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/level/Level1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
