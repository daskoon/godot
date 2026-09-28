class_name SpikeHazard
extends Area2D

## SpikeHazard.gd
## Red hazard spikes that deal damage to the player when touched.

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.call("take_damage")
