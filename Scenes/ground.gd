extends Node2D

class_name Ground

@export var GROUND_SPEED = -100

@onready var piece1 = $Node2D/Sprite2D
@onready var piece2 = $Node2D2/Sprite2D
@onready var piece3 = $Node2D3/Sprite2D

signal bat_crashed

var speed

func _ready():
	speed = 0
	


func start():
	speed = GROUND_SPEED
	

func _process(delta):
	#cambia la posicion de los suelos cada frame para simular movimiento del jugador
	piece1.global_position.x += speed * delta
	piece2.global_position.x += speed * delta
	piece3.global_position.x += speed * delta
	
	# checa la posision de cada suelo y lo pone al final del ultimo si esta fuera de vista 
	if piece1.global_position.x <= -piece1.texture.get_width() / 2:
		piece1.global_position.x = piece3.global_position.x + piece3.texture.get_width()
	
	if piece2.global_position.x <= -piece2.texture.get_width() / 2:
		piece2.global_position.x = piece1.global_position.x + piece1.texture.get_width()
	
	if piece3.global_position.x <= -piece3.texture.get_width() / 2:
		piece3.global_position.x = piece2.global_position.x + piece2.texture.get_width()
	


func _on_body_entered(body):
	bat_crashed.emit()
	stop()
	(body as Bat).stop()
	


func stop():
	speed = 0
	

