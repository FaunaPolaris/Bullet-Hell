extends Node2D

var	asteroid = preload("res://scenes/smallAsteroid.tscn")
var	asteroid2 = preload("res://scenes/mediumAsteroid.tscn")
var	healthPickup = preload("res://scenes/health_pickup.tscn")
var	ammoPickup = preload("res://scenes/ammo_pickup.tscn")

var	safe_range_to_spawn = Vector2(1000, 1000)

var asteroid_count : int = 0
var	pickup_count : int = 0
var	instance

func _process(_delta):
	spawnAsteroids()
	spawnPickups()

func	spawnPickups():
	if pickup_count < 20:
		if randi_range(0, 6) == 0:
			instance = ammoPickup.instantiate()
		else:
			instance = healthPickup.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			pickup_count += 1
			add_child(instance)

func	spawnAsteroids():
	if asteroid_count < 200:
		if randi_range(0, 16) == 0:
			instance = asteroid.instantiate()
		else:
			instance = asteroid2.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			asteroid_count += 1
			add_child(instance)

