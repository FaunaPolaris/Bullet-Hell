extends Area2D

var Player
var	has_healed : bool = false

func	_ready():
	Player = get_parent().get_node("Player")
	$art.play("default")

func _process(_delta):
	if has_overlapping_areas() && !has_healed:
		if Player.health < Player.max_health:
			has_healed = true
			Player.health += 1
			get_parent().pickup_count -= 1
			queue_free()
