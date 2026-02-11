extends CharacterBody2D


const SPEED = 20000.0
const JUMP_VELOCITY = -400.0

@onready var animation_tree: AnimationTree = $AnimationTree

var is_attacking = false


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("attack"):
		animation_tree.get("parameters/playback").travel("Attack")
		is_attacking = true
		print(str(is_attacking))
	if !is_attacking:
		var input_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		if input_dir == Vector2.ZERO:
			animation_tree.get("parameters/playback").travel("Idle")
		else:
			animation_tree.get("parameters/playback").travel("Walk")
			animation_tree.set("parameters/Idle/BlendSpace2D/blend_position", input_dir)
			animation_tree.set("parameters/Walk/BlendSpace2D/blend_position", input_dir)
			animation_tree.set("parameters/Attack/BlendSpace2D/blend_position", input_dir)
		#if input_dir:
		velocity = input_dir.normalized() * delta * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.y = move_toward(velocity.y, 0, SPEED)
		#if input_dir.x:
			#velocity.x = input_dir.x * delta * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
		#if input_dir.y:
			#velocity.y = input_dir.y * delta * SPEED
		#else:
			#velocity.y = move_toward(velocity.y, 0, SPEED)

		move_and_slide()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		is_attacking = false
