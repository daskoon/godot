extends Node

## SoundManager.gd
## Central SFX & Audio AudioStreamPlayer pool manager.

const POOL_SIZE := 8
var _players: Array[AudioStreamPlayer] = []

var _sfx_cache: Dictionary = {}

func _ready() -> void:
	for i in range(POOL_SIZE):
		var p = AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
		
	# Preload SFX
	_preload_sfx("jump", "res://assets/retro_sfx_cc0/jump.wav")
	_preload_sfx("coin", "res://assets/retro_sfx_cc0/coin.wav")

func _preload_sfx(key: String, path: String) -> void:
	if ResourceLoader.exists(path):
		_sfx_cache[key] = ResourceLoader.load(path)

func play_sfx(sfx_name: String, volume_db: float = 0.0) -> void:
	if not _sfx_cache.has(sfx_name):
		return
	var stream = _sfx_cache[sfx_name] as AudioStream
	if not stream:
		return
		
	for p in _players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.play()
			return
	_players[0].stream = stream
	_players[0].volume_db = volume_db
	_players[0].play()
