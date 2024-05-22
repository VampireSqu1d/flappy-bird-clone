extends Node

class_name  ObstacleSpawner

signal bat_scored
signal hit_obs

var obstacles = preload("res://Scenes/Obstacles.tscn")

@export var obs_speed = -100

@onready var timer = $SpawnTimer

func _ready():
	timer.timeout.connect(spawn_obstacles)
	

func start_spawning_obs():
	timer.start()

func spawn_obstacles():
	var obs = obstacles.instantiate() as Obstacles
	add_child(obs)
	
	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	obs.position.x = viewport_rect.end.x + 10
	
	var y_size = viewport_rect.size.y
	var mid_screen = y_size / 2
	obs.position.y = randf_range( y_size * 0.15 - mid_screen, y_size * 0.65 - mid_screen)
	
	obs.bat_hit_obstacle.connect(on_bat_entered)
	obs.score_point.connect(on_point_entered)


func _process(_delta):
	for obs in get_children().filter(func (child): return child is Obstacles):
		if (obs as Obstacles).position.x < -300:
			obs.queue_free()
	


func on_bat_entered():
	hit_obs.emit()
	stop()
	


func on_point_entered():
	bat_scored.emit()
	


func stop():
	timer.stop()
	for obs in get_children().filter(func (child): return child is Obstacles):
		(obs as Obstacles).speed = 0
	


func clear_obs():
	for obs in get_children().filter(func (child): return child is Obstacles):
		obs.queue_free()
	
