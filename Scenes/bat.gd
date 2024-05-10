extends CharacterBody2D

class_name Bat

@export var GRAVITY = 400.0 # speed at wich the bat falls
@export var JUMP = 200.0
@export var MAX_FALLING_SPD = 700

var screen_size
var grav
var process_input = false


func _ready():
	screen_size = get_viewport_rect().size # the type of the variable is Rect2
	#reset()
	grav = 0
	


func start():
	grav = GRAVITY
	position.x = screen_size.x/4
	position.y = screen_size.y/2
	%AnimatedSprite2D.set_frame_and_progress(0, 0.0)
	process_input = true
	


func _physics_process(delta):
	
	if velocity.y < MAX_FALLING_SPD:
		velocity.y += delta * grav
	
	if Input.is_action_just_pressed("fly") and process_input:
		velocity.y = -JUMP
		%AnimatedSprite2D.stop()
		%AnimatedSprite2D.play("fly")
		%FlySoundPlayer.stop()
		%FlySoundPlayer.play()
	
	move_and_collide(velocity * delta)
	


func stop():
	velocity.y = 0
	grav = 0
	process_input = false
	%AnimatedSprite2D.stop()
	%AnimatedSprite2D.play("death")
	%DeathSoundPlayer.play()
	

