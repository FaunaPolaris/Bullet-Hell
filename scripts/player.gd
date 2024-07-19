extends CharacterBody2D

var bullet = preload("res://scenes/bullet.tscn")
var	has_bullet : bool = true

const max_acceleration = Vector2(0, -8)
const speed_gain = Vector2(0, 2)
const speed_lost = Vector2(0, 1)
var acceleration = Vector2(0, -3)

var	max_health : int = 3
var health : int = 3
var	ammo : int = 1
var is_destroyed : bool = false

func _process(delta):
	if !is_destroyed:
		move(delta)
		shoot()
		getHit()

func	getHit():
	if $ship/collision.has_overlapping_areas():
			health -= 1
			$hurt_effect.show()
			$hurt_effect/Timer.start()
	if health <= 0:
		$ship.play("explode")
		$ship/trail.hide()
		$ship/trail2.hide()
		is_destroyed = true

func	shoot():
	if Input.is_action_pressed("shootForward") && has_bullet:
		shootFront(ammo)
	elif Input.is_action_pressed("shootBack") && has_bullet:
		shootBackAngle(45, ammo)
	elif Input.is_action_pressed("shootLeft") && has_bullet:
		shootSideways(ammo, -1)
	elif Input.is_action_pressed("shootRight") && has_bullet:
		shootSideways(ammo, 1)

func	shootFront(amount : int):
	var	projectile : Array = [0, 1, 2]
	var	i : int

	has_bullet = false
	if amount > 1:
		amount = 3
		i = -8
	else:
		i = 0
	for shot in amount:
		projectile[shot] = bullet.instantiate()
		projectile[shot].position = global_position + Vector2(i, -32).rotated($ship.rotation)
		projectile[shot].rotation = $ship.global_rotation
		get_parent().add_child(projectile[shot])
		i += 8
	$bullet_cooldown.start()


func	shootSideways(amount : int, side : int) -> void:
	var projectile	: Array = [0, 1, 2]
	var distance	: int
	var	i			: int = -8

	has_bullet = false
	if amount <= 2:
		amount = 2
		distance = 16
	elif amount >= 3:
		amount = 3
		distance = 8
	for shot in amount:
		projectile[shot] = bullet.instantiate()
		projectile[shot].position = global_position + Vector2((16 * side), i).rotated($ship.rotation)
		projectile[shot].rotation_degrees = $ship.global_rotation_degrees + (75 * side)
		get_parent().add_child(projectile[shot])
		i += distance
	$bullet_cooldown.start()

func	shootBackAngle(angle : int, amount : int) -> void:
	var	projectile : Array = [0, 1, 2, 3, 4]
	var	current_angle : int = -angle

	has_bullet = false
	if amount < 3:
		amount = 3
	if amount >= 5:
		amount = 5
		current_angle -= angle
	for shot in amount:
		projectile[shot] = bullet.instantiate()
		projectile[shot].position = global_position + Vector2(0, 24).rotated($ship.rotation)
		projectile[shot].rotation_degrees = $ship.global_rotation_degrees + current_angle + 180
		get_parent().add_child(projectile[shot])
		current_angle += angle
	$bullet_cooldown.start()

func	move(delta : float):
	if Input.is_action_pressed("forward") && acceleration > max_acceleration:
		acceleration -= speed_gain * delta
	elif acceleration < Vector2(0,-3):
		if Input.is_action_pressed("breaks"):
			acceleration += (speed_lost * 3) * delta
		else:
			acceleration += speed_lost * delta
	if Input.is_action_pressed("leftTilt"):
		$ship.play("leftTilt")
		$ship.rotation_degrees -= -(acceleration.y * .4584)
	elif Input.is_action_pressed("rightTilt"):
		$ship.play("rightTilt")
		$ship.rotation_degrees += -(acceleration.y * .4584)
	else:
		$ship.play("default")
	move_and_collide(acceleration.rotated($ship.rotation))


func _on_bullet_cooldown_timeout():
	has_bullet = true


func _on_ship_animation_finished():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
