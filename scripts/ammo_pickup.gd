extends Area2D

var Player
var	has_upgraded = false

func	_ready():
	Player = get_parent().get_node("Player")
	$art.play("default")

func _process(_delta):
	if has_overlapping_areas() && !has_upgraded:
			has_upgraded = false
			Player.ammo += 1
			get_parent().pickup_count -= 1
			queue_free()
