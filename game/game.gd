extends Node

@onready var day_animation: = %DayAnimation
@onready var bgm: = %BGM

@onready var player: = %Player

@onready var timer: = %ScoreTimer

@onready var game_mode_label: = %GameModeLabel
@onready var game_mode_button: = %GameModeButton
@onready var current_score_label: = %CurrentScoreLabel
@onready var best_score_label: = %BestScoreLabel
@onready var start_button: = %StartButton
@onready var controls: = %Controls

const GAME_MODES: Array[GameMode] = [
  preload("res://game/game_modes/easy_mode.tres"),
  preload("res://game/game_modes/normal_mode.tres"),
  preload("res://game/game_modes/hard_mode.tres"),
]

const MUSIC: Array[AudioStreamOggVorbis] = [
  preload("res://assets/log_run_slow_long.ogg"),
  preload("res://assets/log_run_new_long.ogg"),
  preload("res://assets/log_run_long.ogg"),
]

const GAME_MODES_NAMES: Array[String] = [
  "Easy",
  "Normal",
  "Hard",
]

var current_mode: = 1
var current_score: = 0.

var best_scores: BestScores
const BEST_SCORES_PATH: = "user://scores.tres"

func _ready():
  if ResourceLoader.exists(BEST_SCORES_PATH):
      best_scores = load(BEST_SCORES_PATH)
  else:
    best_scores = BestScores.new()

  update_mode(0)
  
  day_animation.play("day_cycle")
  day_animation.seek(135, true, true)

func _unhandled_input(event: InputEvent):
  if not player.alive:
    if event.is_action_pressed("ui_accept"):
      start()
      get_viewport().set_input_as_handled()
    elif event.is_action_pressed("ui_up"):
      update_mode(1)
      get_viewport().set_input_as_handled()
    elif event.is_action_pressed("ui_down"):
      update_mode(-1)
      get_viewport().set_input_as_handled()
    #elif event is InputEventScreenTouch:
      #if event.position.x < get_viewport().size.x / 2.0:
        #player.left_touched = event.pressed
      #else:
        #player.right_touched = event.pressed

func update_mode(value: int):
  current_mode = (current_mode + value + 3) % 3
  player.game_mode = GAME_MODES[current_mode]
  bgm.stream = MUSIC[current_mode]
  bgm.play()
  game_mode_label.text = GAME_MODES_NAMES[current_mode]
  best_score_label.text = "Best: " + str(int(best_scores.scores[current_mode]))

func start():
  player.start()
  game_mode_button.disabled = true
  game_mode_button.visible = false
  start_button.disabled = true
  start_button.visible = false
  controls.visible = true
  current_score_label.text = "Score: 0"
  timer.start()



func _on_game_mode_button_pressed():
  update_mode(+1)


func _on_player_died():
  current_score += timer.time_left
  timer.stop()
  if (current_score > best_scores.scores[current_mode]):
    best_scores.scores[current_mode] = current_score
    ResourceSaver.save(best_scores, BEST_SCORES_PATH)
    best_score_label.text = "Best: " + str(int(current_score))
  current_score = 0
  game_mode_button.disabled = false
  game_mode_button.visible = true
  start_button.disabled = false
  start_button.visible = true
  controls.visible = false


func _on_score_timer_timeout():
  current_score += 1
  current_score_label.text = "Score: " + str(int(current_score))



func _on_start_button_pressed():
  start()


func _on_left_button_button_down():
  player.left_touched = true


func _on_left_button_button_up():
  player.left_touched = false


func _on_right_button_button_down():
  player.right_touched = true


func _on_right_button_button_up():
  player.right_touched = false
