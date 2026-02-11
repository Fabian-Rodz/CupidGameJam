extends CharacterBody2D

var attacking = false

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _process(delta):
	if Input.is_action_just_pressed("attack") and not attacking:
		attack()

func attack():
	attacking = true
	$AnimationPlayer.play("attack")
	#wait until the animation is finished
	await $AnimationPlayer.animation_finished
	#reset flag
	attacking = false
	#reset to  idle -> for now
	$AnimationPlayer.play("idle")

			

		
		
