extends CharacterBody2D

var attacking = false
var can_move = true
func _ready() -> void:
	play_animation("idle")


func _process(_delta):
	if not attacking:
		if Input.is_action_just_pressed("attack") and not attacking:
			attack()
		if Input.is_action_just_pressed("move_left"):
			if scale.x > 0:
				scale.x = scale.x * -1
			play_animation("walk")
		if Input.is_action_just_pressed("move_right"):
			if scale.x < 0:
				scale.x = scale.x * -1
			play_animation("walk")

func attack():
	attacking = true
	play_animation("attack")
	#wait until the animation is finished
	await $AnimationPlayer.animation_finished
	#reset flag
	attacking = false
	#reset to  idle -> for now
	play_animation("idle")

func _on_hit_box_area_area_exited(area: Area2D) -> void:
	play_animation("take_damage")
	
	
func play_animation(animation):
	if attacking:
		$AnimationPlayer.play(animation)
		return
	if animation != "walk":
		can_move = false
	$AnimationPlayer.play(animation)
	await $AnimationPlayer.animation_finished
	can_move = true
