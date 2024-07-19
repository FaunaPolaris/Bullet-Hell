extends Node2D

var	asteroid = preload("res://scenes/smallAsteroid.tscn")
var	asteroid2 = preload("res://scenes/mediumAsteroid.tscn")
var	healthPickup = preload("res://scenes/health_pickup.tscn")
var	ammoPickup = preload("res://scenes/ammo_pickup.tscn")
var	saucer = preload("res://scenes/common_saucer.tscn")
var	mothership = preload("res://scenes/mothership.tscn")


var	safe_range_to_spawn = Vector2(1000, 1000)

var asteroid_count : int = 0
var	pickup_count : int = 0
var	mothership_count : int = 0
var	orfan_saucers_count : int = 0
var	aliens_killed : int = 0
var	instance

func _process(_delta):
	spawnAsteroids()
	$Player/alien_counter/counts.text = str(aliens_killed)

func	spawnEnemies():
	if orfan_saucers_count < 20:
		instance = saucer.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.global_position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			orfan_saucers_count += 1
			instance.where_to_go = $Player.global_position
			add_child(instance)
	if mothership_count < 3 and randi_range(1, 16) == 1:
		instance = mothership.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.global_position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			mothership_count += 1
			add_child(instance)

func	spawnPickups():
	if pickup_count < 20:
		if randi_range(1, 6) == 1:
			instance = ammoPickup.instantiate()
		else:
			instance = healthPickup.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.global_position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			pickup_count += 1
			add_child(instance)

func	spawnAsteroids():
	if asteroid_count < 200:
		if randi_range(1, 8) != 1:
			instance = asteroid.instantiate()
		else:
			instance = asteroid2.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			asteroid_count += 1
			add_child(instance)



func _on_spawn_timeout():
	spawnPickups()
	spawnEnemies()
