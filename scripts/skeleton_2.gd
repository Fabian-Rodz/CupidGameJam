extends CharacterBody2D

var attacking = false

func _ready() -> void:
	$AnimationPlayer.play("walk")

func _process(_delta):
	if Input.is_action_just_pressed("attack") and not attacking:
		attack()
	if Input.is_action_just_pressed("move_left"):
		if scale.x > 0:
			scale.x = scale.x * -1
		$AnimationPlayer.play("walk")
	if Input.is_action_just_pressed("move_right"):
		if scale.x < 0:
			scale.x = scale.x * -1
		$AnimationPlayer.play("walk")

func attack():
	attacking = true
	$AnimationPlayer.play("attack")
	#wait until the animation is finished
	await $AnimationPlayer.animation_finished
	#reset flag
	attacking = false
	#reset to  idle -> for now
	$AnimationPlayer.play("idle")
