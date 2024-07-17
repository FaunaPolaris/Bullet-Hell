extends Area2D

var	is_collectble : bool = true

func	_process(_delta):
	if has_overlapping_areas():
		get_overlapping_areas()[0].cargo += 1
		is_collectble = false
		queue_free()
