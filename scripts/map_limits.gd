extends Node2D

const	small_map_size = [Vector2(-4000, -4000), Vector2(4000, 4000)]
const	extra_room : int = 300

var		map_size = small_map_size

func	getRandomPossiblePosition() -> Vector2:
	var output : Vector2 = Vector2.ZERO

	output.x = randf_range(map_size[0].x, map_size[1].x)
	output.y = randf_range(map_size[0].y, map_size[1].y)

	return output
