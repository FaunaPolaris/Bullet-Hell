extends Node2D

var	asteroid = preload("res://scenes/smallAsteroid.tscn")
var	asteroid2 = preload("res://scenes/mediumAsteroid.tscn")
var	safe_range_to_spawn = Vector2(1000, 1000)

var asteroid_count : int = 0
var	chance_of_spawn : int = 0
var	instance

func _process(delta):
	chance_of_spawn = randi_range(0, 10000)
	if chance_of_spawn < 5000 && asteroid_count < 100:
		if randi_range(0, 3) == 0:
			instance = asteroid.instantiate()
		else:
			instance = asteroid2.instantiate()
		instance.position = $mapLimits.getRandomPossiblePosition()
		if abs(instance.position - $Player.position) < safe_range_to_spawn:
			instance.queue_free()
		else:
			asteroid_count += 1
			add_child(instance)



	
