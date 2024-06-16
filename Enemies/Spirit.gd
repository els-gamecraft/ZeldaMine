extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var end_point: Marker2D

@onready var animations = $AnimationPlayer

var start_position
var end_position
var is_dead: bool = false

func _ready() -> void:
	start_position = position
	end_position = end_point.global_position

func change_direction() -> void:
	var tempt_end = end_position
	end_position = start_position
	start_position = tempt_end
	
func update_velocity() -> void:
	var move_direction = (end_position - position)
	if move_direction.length() < limit:
		change_direction()
		
	velocity = move_direction.normalized() * speed
	
func update_animation() -> void:
	var animation_string = "WalkUp"
	if velocity.y > 0:
		animation_string = "WalkDown"
		
	animations.play(animation_string)

func _physics_process(delta: float) -> void:
	if is_dead: return
	update_velocity()
	move_and_slide()
	update_animation()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == $HitBox: return
	$HitBox.set_deferred("monitorable", false)
	is_dead = true
	animations.play("Death")
	await animations.animation_finished
	queue_free()
