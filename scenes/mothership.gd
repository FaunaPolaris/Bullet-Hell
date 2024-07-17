extends Area2D

var commonTroop = preload("res://scenes/common_saucer.tscn")

var	speed = Vector2(0, -1)
var	bullet = preload("res://scenes/enemy_bullet.tscn")

var	nearest_object = Vector2.ZERO
var	direction_to_go = Vector2.ZERO
var	common_limit : int = 10

var	troop_to_summon : int = NONE
enum{
	COMMON,
	NONE
}

var	current_state : int
enum{
	OPENING,
	CLOSING,
	CLOSED
}

var	commonTroops = []
var	cargo : int = 148

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
	buildTroops()
	findDirection()
	for troop in commonTroops:
		troop.collector_position = global_position

func	buildTroops():
	if cargo >= 25 && commonTroops.size() < common_limit && troop_to_summon == NONE:
		$ship.play("open hatch")
		current_state = OPENING
		troop_to_summon = COMMON

func	findDirection():
	if $vision.has_overlapping_areas():
		nearest_object = Vector2(10000, 10000)
		for possible_object in $vision.get_overlapping_areas():
			if possible_object.global_position - global_position < nearest_object:
				nearest_object = possible_object.global_position
		direction_to_go = global_position.direction_to(nearest_object)
	
	if (nearest_object.rotated(rotation)).x < (global_position.rotated(rotation)).x:
		rotation_degrees += .1
	elif (nearest_object.rotated(rotation)).x > (global_position.rotated(rotation)).x:
		rotation_degrees -= .1


func _on_ship_animation_finished():
	var	new_troop
	
	if troop_to_summon == COMMON:
		new_troop = commonTroop.instantiate()
		commonTroops.append(new_troop)
		new_troop.position = global_position - Vector2(0, 32)
		new_troop.rotation = randf_range(0, 360)
		new_troop.collector_position = global_position
		get_parent().add_child(new_troop)
		troop_to_summon = NONE
		$ship.play("close hatch")
		cargo -= 25
	elif troop_to_summon == NONE:
		$ship.play("default")
