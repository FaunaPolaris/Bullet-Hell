extends Area2D


const	SPEED = Vector2(0, -8)
var		acceleration = Vector2.ZERO

func	_process(delta):
	acceleration = SPEED + Vector2.ONE * delta
	position += acceleration.rotated(rotation)
	if has_overlapping_areas() or has_overlapping_bodies():
		queue_free()


func _on_lifespam_timeout():
	queue_free()
