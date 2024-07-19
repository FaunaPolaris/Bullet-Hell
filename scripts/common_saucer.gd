extends Area2D

var	speed = Vector2(0, -2)
var	bullet = preload("res://scenes/enemy_bullet.tscn")

var	has_bullet : bool = false
var	where_to_go : Vector2
var	mother = 0

func	_process(delta):
	position += (speed + Vector2.ONE * delta).rotated(rotation)
	if global_position.y < -4100 or global_position.y > 4100 or global_position.x < -4100 or global_position.x > 4100:
		rotation_degrees += 1
	if has_overlapping_areas():
		$ship.play("explode")
	findDirection()

func	findDirection():
	if !where_to_go:
		return
	if $player_looker.has_overlapping_areas():
		where_to_go = $player_looker.get_overlapping_areas()[0].global_position
	var	direction = (global_position.direction_to(where_to_go)).normalized()
	var	angle_to_collector = rad_to_deg(direction.angle())
	var angle_diff = angle_to_collector - rotation_degrees
	var	distance_to_collector = where_to_go.distance_to(global_position)
	var rotation_speed = clamp(distance_to_collector * .001, 0.1, 1)
	
	angle_diff = wrapAngle(angle_diff)
	if abs(angle_diff) > 1:
			rotation_degrees += clamp(angle_diff, -rotation_speed, rotation_speed)
	rotation_degrees = wrapAngle(rotation_degrees)

func wrapAngle(angle) -> float:
	angle = fmod(angle + 180, 360)
	if angle < 0:
		angle += 360
	return angle - 180

func _on_bullet_cooldown_timeout():
	var _bullet
	for ammo in 3:
		_bullet = bullet.instantiate()
		_bullet.position = global_position
		_bullet.rotation = randf_range(0, 360)
		get_parent().add_child(_bullet)
	has_bullet = true


func _on_ship_animation_finished():
	if mother:
		mother.commonTroops.erase(self)
	else:
		get_parent().orfan_saucers_count -= 1
	get_parent().aliens_killed += 1
	queue_free()
