extends Node2D

class_name Obstacles

@export var OBSTACLES_SPEED = -100

signal bat_hit_obstacle
signal score_point

var speed

func _ready():
	speed = OBSTACLES_SPEED
	


func _process(delta): 
	position.x += speed * delta
	


func stop():
	speed = 0
	


func _on_body_entered(body):
	bat_hit_obstacle.emit()
	stop()
	(body as Bat).stop()
	


func _on_score_area_body_entered(_body):
	score_point.emit()
	
