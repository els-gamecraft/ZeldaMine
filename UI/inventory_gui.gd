extends Control

signal opened
signal closed

var is_open: bool = false

@onready var inventory: Inventory = preload("res://Inventory/Items/player_inventory.tres")
@onready var item_stack_gui_class = preload("res://UI/items_stack_UI.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
	connect_slots()
	inventory.updated.connect(update)
	update()

func connect_slots() -> void:
	for slot in slots:
		var callable = Callable(on_slot_clicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventory_slot: InventorySlot = inventory.slots[i]
		
		if !inventory_slot.item: continue
		
		var item_stack_gui: ItemStackGui = slots[i].item_stack_gui
		if !item_stack_gui:
			item_stack_gui = item_stack_gui_class.instantiate()
			slots[i].insert(item_stack_gui)
			
		item_stack_gui.inventory_slot = inventory_slot
		item_stack_gui.update()

func open() -> void:
	visible = true
	is_open = true
	opened.emit()
	
func close() -> void:
	visible = false
	is_open = false
	closed.emit()

func on_slot_clicked(slot) -> void:
	pass
