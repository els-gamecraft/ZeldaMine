extends CharacterBody2D
class_name Player

signal health_changed

@export var speed: int = 45
@onready var animations = $AnimationPlayer
@onready var effects: AnimationPlayer = $Effects
@onready var hurt_box: Area2D = $HurtBox
@onready var hurt_timer: Timer = $HurtTimer
@onready var weapon: Node2D = $Weapon
@export var max_health = 3
@onready var current_health: int = max_health
@export var knockback_power: int = 500
@export var inventory: Inventory

var last_anim_direction: String = "Down"
var is_hurt: bool = false
var is_attacking: bool = false

func _ready() -> void:
	effects.play("RESET")

func handleInput() -> void:
	var moveDrirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDrirection * speed
	
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack() -> void:
	animations.play("Attack" + last_anim_direction)
	is_attacking = true
	weapon.enable()
	await animations.animation_finished
	weapon.disable()
	is_attacking = false
	
func updateAnimation() -> void:
	if is_attacking: return
	
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("Walk" + direction)
		last_anim_direction = direction

func handle_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func _physics_process(delta: float) -> void:
	handleInput()
	move_and_slide()
	handle_collision()
	updateAnimation()
	if !is_hurt:
		for area in hurt_box.get_overlapping_areas():
			if area.name == "HitBox":
				hurt_by_enemy(area)

func hurt_by_enemy(area) -> void:
	current_health -= 1
	if current_health < 0:
		current_health = max_health
	health_changed.emit(current_health)
	is_hurt = true
	knockback(area.get_parent().velocity)
	effects.play("HurtBlink")
	hurt_timer.start()
	await hurt_timer.timeout
	effects.play("RESET")
	is_hurt = false

func _on_hurt_box_area_entered(area: Area2D) -> void: 
	if area.has_method("collect"):
		area.collect(inventory)
	
func knockback(enemy_velocity: Vector2) -> void:
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	#print_debug(velocity)
	#print_debug(position)
	velocity = knockback_direction
	move_and_slide()
	#print_debug(position)
	#print_debug(" ")

func _on_hurt_box_area_exited(area: Area2D) -> void: pass
