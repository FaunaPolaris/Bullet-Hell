extends CharacterBody2D

const max_acceleration = Vector2(0, -10)
const speed_gain = Vector2(0, .1)
var acceleration = Vector2(0, -1)

func _process(delta):
	if Input.is_action_pressed("ui_up") && acceleration > max_acceleration:
		acceleration -= speed_gain
	elif acceleration < Vector2(0,-1):
		acceleration += speed_gain
	if Input.is_action_pressed("ui_left"):
		$ship.play("leftTilt")
		rotation -= .02
	elif Input.is_action_pressed("ui_right"):
		$ship.play("rightTilt")
		rotation += .02
	else:
		$ship.play("default")
	position += acceleration.rotated(rotation)
