extends Node

@onready var ground = %Ground as Ground
@onready var bat = %Bat as Bat
@onready var obstablesSpw = %ObstacleSpawner as ObstacleSpawner
@onready var scoreLabel = %Score as Label
@onready var restartLabel = %RestartLabel as Label
@onready var startLabel = %StartLabel as Label
@onready var HighscoreLabel = %HighscoreLabel as Label
@onready var mute_button = %MuteButton as Button
@onready var unmute_button = %UnmuteButton as Button
@onready var credits_button = %CreditsButton as Button

var score: int = 0
var muted: bool # this var is showing the right sound button

# variables for audio buses
var music = AudioServer.get_bus_index("Music")
var soundFX = AudioServer.get_bus_index("SoundFX")


# saved data info
const save_file_path: String = "user://flappy_bat_data.tres"
var savedDataResource = SaveData.new()


func _ready():
	#connect the signals when the game loads
	ground.bat_crashed.connect(end_game)
	obstablesSpw.hit_obs.connect(end_game)
	obstablesSpw.bat_scored.connect(score_point)
	
	#load saved highscore if exists
	if ResourceLoader.exists(save_file_path):
		load_data()
		update_score_label()
		muted = savedDataResource.muted_sound
		if muted:
			_on_mute_button_pressed()
		
	


func save_data():
	ResourceSaver.save(savedDataResource, save_file_path)
	


func load_data():
	savedDataResource = ResourceLoader.load(save_file_path).duplicate(true)
	


func start_game():
	obstablesSpw.clear_obs() #clear obstables from game 
	obstablesSpw.start_spawning_obs()
	bat.visible = true
	bat.start() # enables bat gravity
	ground.start() # makes ground start moving
	#make ui elements not visible
	startLabel.visible = false
	restartLabel.visible = false
	HighscoreLabel.visible = false
	mute_button.visible = false
	unmute_button.visible = false
	credits_button.visible = false
	
	#resets score and its label
	score = 0
	scoreLabel.text = "0"
	


func end_game():
	ground.stop()
	bat.stop()
	obstablesSpw.stop()
	restartLabel.visible = true
	HighscoreLabel.visible = true
	credits_button.visible = true
	
	#check for wich sound button to show
	if !muted:
		mute_button.visible = true
	else: 
		unmute_button.visible = true
	
	#saves new highscore if reached
	if score > savedDataResource.highscore:
		savedDataResource.update_highscore(score)
		save_data()
	
	update_score_label()
	


func pause_game():
	pass


func update_score_label():
	HighscoreLabel.text = "Score: " + str(score) +"\n Highscore: " + str(savedDataResource.highscore)
	


func score_point():
	score += 1
	scoreLabel.text = str(score)
	$ScoreAudioPlayer.stop()
	$ScoreAudioPlayer.play()
	


func _on_restart_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ClickSoundPlayer.play()
		start_game() # method for restarting and keeping the highscore
	


func _on_start_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$ClickSoundPlayer.play()
		start_game()
	


func _on_mute_button_pressed():
	toggle_sound()
	muted = true
	#saves muted setting to file
	savedDataResource.update_muted_sound(muted)
	save_data()
	mute_button.visible = false
	unmute_button.visible = true
	


func _on_unmute_button_pressed():
	toggle_sound()
	muted = false
	#saves muted setting to file
	savedDataResource.update_muted_sound(muted)
	save_data()
	mute_button.visible = true
	unmute_button.visible = false
	


func toggle_sound():#function that get mutes both audio buses
	AudioServer.set_bus_mute(music, not AudioServer.is_bus_mute(music))
	AudioServer.set_bus_mute(soundFX, not AudioServer.is_bus_mute(soundFX))
	


func _on_credits_button_pressed():
	%MainUINode.visible = false
	%CreditsContainer.visible = true


func _on_back_arrow_button_pressed():
	%MainUINode.visible = true
	%CreditsContainer.visible = false
