extends "res://scripts/smallAsteroid.gd"

var parts = preload("res://scenes/smallAsteroid.tscn")

func _on_art_animation_finished():
	if has_hit_something:
		print("medium asteroid destroyed")
		get_parent().asteroid_count += 1
		var instance = parts.instantiate()
		instance.position = global_position + Vector2(20, 0)
		get_parent().add_child(instance)
		instance = parts.instantiate()
		instance.position = global_position + Vector2(-20, 0)
		get_parent().add_child(instance)
		queue_free()
