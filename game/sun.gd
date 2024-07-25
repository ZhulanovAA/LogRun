@tool
extends Sprite2D

@export var day_angle: float

const X_RADIUS: = 1000
const Y_RADIUS: = 700

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  global_position.x = 1920. / 2 + X_RADIUS * sin(deg_to_rad(day_angle))
  global_position.y = 1080 - 320 - Y_RADIUS * cos(deg_to_rad(day_angle))
