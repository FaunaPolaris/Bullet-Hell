extends Node2D

var game_loop = preload("res://scenes/main_loop.tscn")

func _process(delta):
	position.x += .3
	if Input.is_action_pressed("startGame"):
		get_tree().change_scene_to_packed(game_loop)
