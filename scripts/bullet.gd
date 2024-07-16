extends Area2D

const	SPEED = Vector2(0, -15)
var		acceleration = Vector2.ZERO

func	_ready():
	$art.play("default")

func	_process(delta):
	acceleration = SPEED + Vector2.ONE * delta
	position += acceleration.rotated(rotation)
	if has_overlapping_areas() or has_overlapping_bodies():
		print("bullet destroyed")
		queue_free()
