extends Area2D

@export var item_res: InventoryItem

func collect(inventory: Inventory) -> void:
	inventory.insert(item_res)
	queue_free()
