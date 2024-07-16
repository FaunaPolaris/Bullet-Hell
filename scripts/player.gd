extends CharacterBody2D

var bullet = preload("res://scenes/bullet.tscn")
var	has_bullet : bool = false

const max_acceleration = Vector2(0, -15)
const speed_gain = Vector2(0, 2)
const speed_lost = Vector2(0, 4)
var acceleration = Vector2(0, -3)
var	rotation_ratio = .04

var health : int = 3
var is_destroyed : bool = false

func _process(delta):
	if !is_destroyed:
		move(delta)
		shoot()
		getHit()

func	getHit():
	if $collision.has_overlapping_areas():
			health -= 1
			$hurt_effect.show()
			$hurt_effect/Timer.start()
	if health <= 0:
		$ship.play("explode")
		$trail.hide()
		$trail2.hide()
		is_destroyed = true

func	shoot():
	if Input.is_action_pressed("shoot") && has_bullet:
		var projectile = bullet.instantiate()
		projectile.position = global_position + Vector2(0, -32).rotated(rotation)
		projectile.rotation = global_rotation
		get_parent().add_child(projectile)
		has_bullet = false

func	move(delta : float):
	if Input.is_action_pressed("ui_up") && acceleration > max_acceleration:
		acceleration -= speed_gain * delta
	elif acceleration < Vector2(0,-3):
		acceleration += speed_lost * delta
	if Input.is_action_pressed("ui_left"):
		$ship.play("leftTilt")
		rotation -= rotation_ratio
	elif Input.is_action_pressed("ui_right"):
		$ship.play("rightTilt")
		rotation += rotation_ratio
	else:
		$ship.play("default")
	move_and_collide(acceleration.rotated(rotation))


func _on_bullet_cooldown_timeout():
	has_bullet = true
