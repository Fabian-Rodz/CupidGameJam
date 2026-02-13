extends PathFollow2D

var speed = 70.0  
var chase_speed = 60.0 
var last_position = Vector2.ZERO
var last_direction = 0
var attack_range = 15

var player = null
var can_move_path = true

func _ready():
	last_position = global_position

func _process(delta: float) -> void:
	if get_child_count() == 0:
		return
	var enemy = get_child(0)
	if not enemy:
		return
	if not enemy.attacking:
		if can_move_path:
			move_along_path(delta)
		elif player:
			chase_player(delta)

	flip_logic()

func move_along_path(delta):
	var path = get_parent()  #Path2D
	var path_length = path.curve.get_baked_length()
	progress_ratio += (speed * delta) / path_length

func chase_player(delta):
	var enemy = get_child(0)
	var vector_to_player = player.global_position - enemy.global_position
	var distance = vector_to_player.length()

	if distance > attack_range:
		var direction = vector_to_player.normalized()
		# Usando velocity y move_and_slide
		enemy.velocity = direction * chase_speed
		enemy.move_and_slide()
	else:
		if not enemy.attacking:
			enemy.velocity = Vector2.ZERO 
			enemy.attack()  # async attack function in enemy script


func flip_logic():
	var enemy = get_child(0)
	var movement = Vector2.ZERO

	if can_move_path:
		movement = global_position - last_position
	elif player:
		movement = player.global_position - global_position

	var current_direction = sign(movement.x)
	if current_direction != 0 and current_direction != last_direction:
		enemy.scale.x *= -1
		last_direction = current_direction

	last_position = global_position

func _on_player_detector_follow_player(player_hitbox: Area2D) -> void:
	can_move_path = false
	player = player_hitbox
