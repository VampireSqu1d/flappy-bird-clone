extends Node

@onready var ground = %Ground as Ground
@onready var bat = %Bat as Bat
@onready var obstablesSpw = %ObstacleSpawner as ObstacleSpawner
@onready var scoreLabel = %Score as Label
@onready var labelsContainer = %CenterContainer as VBoxContainer
@onready var RestartLabel = %RestartLabel as Label
@onready var startLabel = %StartLabel as Label
@onready var HighscoreLabel = %HighscoreLabel as Label

var score: int = 0
var highscore: int = 0


func _ready():
	ground.bat_crashed.connect(end_game)
	obstablesSpw.hit_obs.connect(end_game)
	obstablesSpw.bat_scored.connect(score_point)
	


func start_game():
	obstablesSpw.clear_obs()
	obstablesSpw.start_spawning_obs()
	bat.visible = true
	bat.start()
	ground.start()
	labelsContainer.visible = false
	HighscoreLabel.visible = false
	score = 0
	scoreLabel.text = "0"
	


func end_game():
	ground.stop()
	bat.stop()
	obstablesSpw.stop()
	labelsContainer.visible = true
	RestartLabel.visible = true
	HighscoreLabel.visible = true
	startLabel.visible = false
	
	if score > highscore:
		highscore = score
	
	HighscoreLabel.text = "Score: " + str(score) +"\n Highscore: " + str(highscore)
	


func score_point():
	score += 1
	scoreLabel.text = str(score)
	


func _on_restart_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ClickSoundPlayer.play()
		#get_tree().reload_current_scene() #reaload the scene from 0, also restarts the highscore var
		start_game() # method for restarting and keeping the highscore
	


func _on_start_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ClickSoundPlayer.play()
		start_game()
	
