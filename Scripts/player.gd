extends CharacterBody2D


const SPEED = 120.0
const ROLL_SPEED = 240.0
const JUMP_VELOCITY = -70.0

@onready var sprite: AnimatedSprite2D = $PlayerAnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hurt_timer: Timer = $HurtTimer
@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/HurtboxCollisionShape2D
@onready var hurtbox_aread2D: Area2D = $Hurtbox

@export var projectile_scene: PackedScene

var can_move = true
var is_hurt = false
var is_dead = false
var lives
var time 
@export var is_rolling = false
var direction_facing = Vector2(1,0)
var projectile_power_active = false

func _ready() -> void:
	lives = 3
	animation_tree.set("parameters/Attack/BlendSpace2D/blend_position", direction_facing)
	animation_tree.set("parameters/Roll/BlendSpace2D/blend_position", direction_facing)
	enable_collision()

func disabled_collision():
	hurtbox_collision.set_deferred("disabled", true)
	
func disable_collision_layer():
	hurtbox_aread2D.set_collision_layer_value(1,false)
	hurtbox_aread2D.set_collision_mask_value(2,false)

func enable_collision():
	hurtbox_collision.set_deferred("disabled", false)

func enable_collision_layer():
	hurtbox_aread2D.set_collision_layer_value(1,true)
	hurtbox_aread2D.set_collision_mask_value(2,true)
	
func hurt_sequence():
	animation_tree.get("parameters/playback").travel("Hurt")
	lives -= 1
	print("Damage taken! Only " + str(lives) + " lives remaining")
	time = 1.0
	can_move = false
	is_hurt = true
	hurt_timer.start()

func death_sequence():
	animation_tree.get("parameters/playback").travel("Death")
	can_move = false
	disabled_collision()
	is_dead = true
	#is_hurt = true

func _physics_process(delta: float) -> void:
	# damage test
	if Input.is_action_just_pressed("ui_cancel"):
		if !is_hurt:
			if lives > 1:
				hurt_sequence()
			else:
				death_sequence()
	
	
	#Handle roll pt1
	if Input.is_action_just_pressed("roll") and can_move:
		animation_tree.get("parameters/playback").travel("Roll")
		velocity = direction_facing
		can_move = false
		is_rolling = true
	
	# Handle roll pt2
	if is_rolling:
		velocity = direction_facing.normalized() * ROLL_SPEED
		move_and_slide()
	
	# Handle attack
	if Input.is_action_just_pressed("attack") and can_move:
		animation_tree.get("parameters/playback").travel("Attack")
		can_move = false
		##### PROJECTILE
		if projectile_power_active:
			var projectile = projectile_scene.instantiate() 
			projectile.direction = direction_facing
			projectile.position = position
			add_sibling(projectile)

	# Handle movement
	if can_move:
		var input_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		if input_dir == Vector2.ZERO:
			animation_tree.get("parameters/playback").travel("Idle")
		else:
			direction_facing = input_dir
			animation_tree.get("parameters/playback").travel("Walk")
			animation_tree.set("parameters/Idle/BlendSpace2D/blend_position", input_dir)
			animation_tree.set("parameters/Walk/BlendSpace2D/blend_position", input_dir)
			animation_tree.set("parameters/Attack/BlendSpace2D/blend_position", input_dir)
			animation_tree.set("parameters/Roll/BlendSpace2D/blend_position", input_dir)
	
		velocity = input_dir.normalized() * SPEED
		move_and_slide()
	
	# Hurt blink animation
	if is_hurt:
		if hurt_timer.time_left < time:
			if visible == true:
				visible = false
			else:
				visible = true
			time -= 0.2
	else:
		visible = true
	
	# Collision detection handling
	if is_hurt or is_rolling:
		disable_collision_layer()
	elif !is_hurt and !is_rolling and !is_dead:
		enable_collision_layer()



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name or "roll" in anim_name or "hurt" in anim_name:
		can_move = true
	if "death" in anim_name:
		sprite.hide()



func _on_hurt_timer_timeout() -> void:
	is_hurt = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer == 4 and not is_rolling:
		if !is_hurt:
			if lives > 1:
				hurt_sequence()
			else:
				death_sequence()
		print("Contact")


func _on_power_pickup_give_power() -> void:
	projectile_power_active = true
