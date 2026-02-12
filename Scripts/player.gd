extends CharacterBody2D


const SPEED = 20000.0
const ROLL_SPEED = 40000.0
const JUMP_VELOCITY = -400.0

@onready var animation_tree: AnimationTree = $AnimationTree

var can_move = true
@export var is_rolling = false
var direction_facing = Vector2(1,0)

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("roll") and can_move:
		animation_tree.get("parameters/playback").travel("Roll")
		velocity = direction_facing
		can_move = false
		is_rolling = true
	
	if is_rolling:
		velocity = direction_facing.normalized() * delta * ROLL_SPEED
		move_and_slide()

	if Input.is_action_just_pressed("attack") and can_move:
		animation_tree.get("parameters/playback").travel("Attack")
		can_move = false

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

		velocity = input_dir.normalized() * delta * SPEED


		move_and_slide()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name or "roll" in anim_name:
		can_move = true
