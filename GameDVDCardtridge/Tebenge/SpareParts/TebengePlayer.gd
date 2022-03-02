extends KinematicBody2D

export(int) var initHP:int = 3
export(float) var speed:float = 5
var movening:Vector2 = Vector2(0,0)
var active:bool = false
export (bool) var enemyMode:bool = false
export(bool) var movesToLeft:bool = false
export(PackedScene) var theBeluru = load("res://GameDVDCardtridge/Tebenge/SpareParts/TebengeBullet.tscn")
var hp:int = 3
var facingLeft:bool = false
export(float) var spaceBetweenBullet:float = 100
export(int) var maximumBullet:int = 5
var currentBulletOnScreen:int = 0
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
			facingLeft = movesToLeft
			pass
			
			# TODO: check hp 0 then destroy
		else:
			if movening != Vector2.ZERO:
				move_and_collide(movening*speed,true)
#				move_and_slide(movening * speed)
			
			if Input.is_action_just_pressed("Tebenge_Kiri"):
				changeFace(true)
			if Input.is_action_just_pressed("Tebenge_Kanan"):
				changeFace(false)
			
			if Input.is_action_just_pressed("Tebenge_Tembak"):
				# balan action abominationss
				shootNow()
	pass

func shootNow():
	if currentBulletOnScreen >= maximumBullet:
		return
	else:
		_spawnBullet()
	var bullet = theBeluru.instance()
	bullet.connect("destroying",self,"_bulletDestroyed")
	if facingLeft:
		pass
	else:
		pass
	bullet.positionNow(position + Vector2(spaceBetweenBullet * (-1 if facingLeft else 1),0))
	bullet.runNow(Vector2(-1 if facingLeft else 1,0))
	get_parent().add_child(bullet,true)
	pass

func _input(event):
	if event is InputEventAction:
#		movening = Vector2(Input.get_axis("Tebenge_Kiri","Tebenge_Kanan"),Input.get_axis("Tebenge_Bawah","Tebenge_Atas"))
		pass

func changeFace(toTheLeft:bool = false):
	facingLeft = toTheLeft
	movesToLeft = toTheLeft
	$Form.flip_h = toTheLeft
	pass

func _spawnBullet():
	currentBulletOnScreen += 1
	pass

func _bulletDestroyed():
	currentBulletOnScreen -= 1
	pass

func _inflictDamage(howMany:int):
	hp -= 1
	pass

func _eikSerkat():
	hp = 0
	pass
