extends KinematicBody2D

export(int) var initHP:int = 3
export(float) var speed:float = 5
var movening:Vector2 = Vector2(0,0)
var active:bool = false
export (bool) var enemyMode:bool = false
export(bool) var movesToLeft:bool = false
var hp:int = 3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hp = initHP
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movening = Vector2(Input.get_axis("Tebenge_Kiri","Tebenge_Kanan"),Input.get_axis("Tebenge_Atas","Tebenge_Bawah"))
	if active:
		if enemyMode:
			move_and_collide(Vector2(speed * (-1 if movesToLeft else 1),0))
			pass
		else:
			if movening != Vector2.ZERO:
				move_and_collide(movening*speed,false)
	pass

func _input(event):
	if event is InputEventAction:
#		movening = Vector2(Input.get_axis("Tebenge_Kiri","Tebenge_Kanan"),Input.get_axis("Tebenge_Bawah","Tebenge_Atas"))
		pass
