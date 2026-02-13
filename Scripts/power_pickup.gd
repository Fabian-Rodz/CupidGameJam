extends Node

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_shape: CollisionShape2D = $CollisionShape2D


signal give_power

var picked_up = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if picked_up and !sprite.is_playing():
		queue_free()



func _on_area_entered(area: Area2D) -> void:
	sprite.play("dissipate")
	pickup_shape.set_deferred("disabled", true)
	picked_up = true
	give_power.emit()
