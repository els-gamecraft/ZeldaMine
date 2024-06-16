extends Node2D

@onready var hearts_container: HBoxContainer = $CanvasLayer/HeartsContainer
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	hearts_container.set_max_hearts(player.max_health)
	hearts_container.update_hearts(player.current_health)
	player.health_changed.connect(hearts_container.update_hearts)

func _on_inventory_gui_closed() -> void:
	get_tree().paused = false

func _on_inventory_gui_opened() -> void:
	get_tree().paused = true
