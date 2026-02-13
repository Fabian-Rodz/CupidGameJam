extends CharacterBody2D

var attacking = false
var can_move = true
var health = 3
func _ready() -> void:
	play_animation("walk")


func _process(_delta):
	pass
	
func attack():
	attacking = true
	play_animation("attack")
	#wait until the animation is finished
	await $AnimationPlayer.animation_finished
	#reset flag
	attacking = false
	play_animation("walk")

func _on_hit_box_area_area_exited(area: Area2D) -> void:
	play_animation("take_damage")
	await $AnimationPlayer.animation_finished
	health-=1
	if health<=0:
		call_deferred("queue_free")
	
	
func play_animation(animation):
	if attacking:
		$AnimationPlayer.play(animation)
		return
	$AnimationPlayer.play(animation)
