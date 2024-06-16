extends Area2D

@onready var shape: CollisionShape2D = $CollisionShape2D

func enable() -> void:
	shape.disabled = false

func disable() -> void:
	shape.disabled = true
