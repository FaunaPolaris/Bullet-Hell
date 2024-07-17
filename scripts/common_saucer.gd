extends Area2D

var	speed = Vector2(0, -2)
var	bullet = preload("res://scenes/enemy_bullet.tscn")

var	has_bullet : bool = false

var	cargo : int = 10
var	player_position : Vector2
var	collector_position : Vector2 = Vector2.ZERO
var	nearest_asteroid = Vector2.ZERO
var	direction_to_go = Vector2.ZERO

var	objective : int = -1
var	complete_objectives : int = 0
enum {
	HUNTING,
	COLLECTING,
	DELIVERING
}

func	_ready():
	player_position = get_parent().get_node("mapLimits").getRandomPossiblePosition()

func _on_think_again_timeout():
	print("carrying: ", cargo, " debrees")
#	screamAround()

func	_process(delta):
	position += ((speed + Vector2.ONE * delta).rotated(rotation))
	if global_position.y < -4100:
		rotation += 1
	if global_position.y > 4100:
		rotation += 1
	if global_position.x < -4100:
		rotation += 1
	if global_position.x > 4100:
		rotation += 1
	processObjectives()

func	processObjectives():
	if objective == -1:
		findNewObjective()
	#elif objective == HUNTING:
		#huntPlayer()
	elif objective == DELIVERING:
		goToCollector()
	elif objective == COLLECTING:
		findAsteroid()

func	goToCollector():
	if collector_position.x < (global_position.rotated(rotation)).x:
		rotation_degrees += 1
	elif collector_position.x > (global_position.rotated(rotation)).x:
		rotation_degrees -= 1
	if cargo == 0:
		objective = -1

func	findAsteroid():
	if $asteroid_looker.has_overlapping_areas():
		nearest_asteroid = Vector2(10000, 10000)
		for possible_asteroid in $asteroid_looker.get_overlapping_areas():
			if possible_asteroid.global_position - global_position < nearest_asteroid:
				nearest_asteroid = possible_asteroid.global_position
		direction_to_go = global_position.direction_to(nearest_asteroid)
		if has_bullet:
			var _bullet = bullet.instantiate()
			_bullet.position = global_position
			_bullet.rotation = ((global_position.x + direction_to_go.x) + (global_position.y + direction_to_go.y))
			get_parent().add_child(_bullet)
			has_bullet = false
		
	if (nearest_asteroid.rotated(rotation)).x < (global_position.rotated(rotation)).x:
		rotation_degrees += .1
	elif (nearest_asteroid.rotated(rotation)).x > (global_position.rotated(rotation)).x:
		rotation_degrees -= .1
	if cargo >= 10:
		objective = -1

#func	goToCollector():
	#rotation = get_angle_to(collector_position)
#
#func	huntPlayer():
	#rotation = get_angle_to(player_position)


func	findNewObjective():
	if complete_objectives == 6:
		objective = HUNTING
	elif cargo >= 10:
		objective = DELIVERING
	else:
		objective = COLLECTING
	print("new objective: ", objective)


func _on_bullet_cooldown_timeout():
	var _bullet
	for ammo in 2:
		_bullet = bullet.instantiate()
		_bullet.position = global_position
		_bullet.rotation = randf_range(0, 360)
		get_parent().add_child(_bullet)
	has_bullet = true
