extends Node2D

signal died

const LOG_ROTATION_SPEED = 360

const DROP_ANGLE = 80

@onready var log_sprite: = $Log
@onready var pivot: = $Pivot
@onready var animation: = $AnimationPlayer

@export var game_mode: GameMode

var alive: = false
var rotation_speed: = .0

var left_touched: = false
var right_touched: = false

func start():
  alive = true
  rotation_speed = 0
  pivot.rotation_degrees = 0
  left_touched = false
  right_touched = false
  animation.play('run')

func die():
  alive = false
  animation.stop()
  died.emit()

func _process(delta: float):
  if alive:
    rotate_log(delta)

func _physics_process(delta):
  if alive:
    apply_fall_rotation(delta)
    apply_speed(delta)
    if abs(pivot.rotation_degrees) >= DROP_ANGLE:
      die()

func rotate_log(delta: float):
  log_sprite.rotation_degrees += LOG_ROTATION_SPEED * delta
  if (log_sprite.rotation_degrees > 360):
    log_sprite.rotation_degrees -= 360

func apply_fall_rotation(delta: float):
  if pivot.rotation_degrees == 0:
    pivot.rotation_degrees = 1
  else:
    pivot.rotation_degrees += pivot.rotation_degrees * game_mode.drop_multiplier * delta

func apply_speed(delta: float):
  var direction: = 0.
  if left_touched or right_touched:
    direction = -int(left_touched) + int(right_touched)
  else:
    direction = Input.get_axis("player_left", "player_right")
  if (direction != 0):
    if (abs(rotation_speed) < game_mode.initial_speed):
      rotation_speed = sign(direction) * game_mode.initial_speed
    else:
      rotation_speed += sign(direction) * game_mode.acceleration * delta
  else:
    rotation_speed = sign(rotation_speed) * max(0, abs(rotation_speed) - game_mode.acceleration * delta)
  pivot.rotation_degrees += rotation_speed * delta


