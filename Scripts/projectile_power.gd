extends CharacterBody2D

const SPEED = 22000
# Called when the node enters the scene tree for the first time.
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D

var direction = Vector2.ZERO

func set_direction(player_direction: Vector2):
	direction = player_direction
	#right
	if direction == Vector2(1,0):
		rotation = deg_to_rad(180.0)
	#left
	elif direction == Vector2(-1,0):
		rotation = deg_to_rad(0)
	#up_left
	elif direction == Vector2(-1,-1):
		rotation = deg_to_rad(45)
	#down_left
	elif direction == Vector2(-1,1):
		rotation = deg_to_rad(315)
	#down_right
	elif direction == Vector2(1,1):
		rotation = deg_to_rad(225.0)
	#up_right
	elif direction == Vector2(1,-1):
		rotation = deg_to_rad(135)
	#down
	elif direction == Vector2(0,1):
		rotation = deg_to_rad(270)
	#up
	elif direction == Vector2(0,-1):
		rotation = deg_to_rad(90)
	else:
		rotation = deg_to_rad(0)


func _ready() -> void:
	if direction == Vector2(1,0):
		rotation = deg_to_rad(180.0)
	#left
	elif direction == Vector2(-1,0):
		rotation = deg_to_rad(0)
	#up_left
	elif direction == Vector2(-1,-1):
		rotation = deg_to_rad(45)
	#down_left
	elif direction == Vector2(-1,1):
		rotation = deg_to_rad(315)
	#down_right
	elif direction == Vector2(1,1):
		rotation = deg_to_rad(225.0)
	#up_right
	elif direction == Vector2(1,-1):
		rotation = deg_to_rad(135)
	#down
	elif direction == Vector2(0,1):
		rotation = deg_to_rad(270)
	#up
	elif direction == Vector2(0,-1):
		rotation = deg_to_rad(90)
	else:
		rotation = deg_to_rad(0)

var projectile_hit = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * SPEED * delta
	move_and_slide()
	
	if projectile_hit and !sprite.is_playing():
		queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	sprite.play("dissipate")
	hitbox_shape.set_deferred("disabled", true)
	direction = Vector2.ZERO
	projectile_hit = true


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
