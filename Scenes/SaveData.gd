extends Resource

class_name SaveData

@export var highscore: int  = 0
@export var muted_sound: bool = false

func update_highscore(value: int):
	highscore = value


func update_muted_sound(value: bool):
	muted_sound = value
