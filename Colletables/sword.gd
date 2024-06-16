extends "res://Colletables/Collectable.gd"

@onready var animations: AnimationPlayer = $AnimationPlayer

func collect(inventory: Inventory) -> void:
	animations.play("Spin")
	await animations.animation_finished
	super.collect(inventory)
