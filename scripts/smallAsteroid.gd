extends StaticBody2D

var has_hit_something : bool = false

var initial_acceleration = Vector2(0, randf_range(-3, -.5))
var initial_rotation = randf_range(-360, 360)
var	acceleration : Vector2

func _ready():
	$art.play("default")
	rotation = initial_rotation

func _process(delta):
	if $collision.has_overlapping_areas() and !has_hit_something:
		has_hit_something = true
		$movement_limiter.disabled = true
		$collision/body.disabled = true
		$art.play("explode")
	acceleration = initial_acceleration + Vector2.ONE * delta
	position += acceleration.rotated(rotation)

func _on_art_animation_finished():
	if has_hit_something:
		print("asteroid destroyed")
		get_parent().asteroid_count -= 1
		queue_free()
