extends Area2D

signal follow_player(player_hitbox)



func _on_area_entered(area: Area2D) -> void:
	follow_player.emit(area)
