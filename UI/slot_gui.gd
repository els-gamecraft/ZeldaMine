extends Button

@onready var background_sprite: Sprite2D = $Background
@onready var container: CenterContainer = $CenterContainer

var item_stack_gui: ItemStackGui

func insert(isg: ItemStackGui) -> void:
	item_stack_gui = isg
	background_sprite.frame = 1
	container.add_child(item_stack_gui)
