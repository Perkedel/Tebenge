extends RigidBody2D

var active:bool = false
export(float) var speed:float = 500
export(bool) var moves_wildly:bool = false
export(float) var lifespanTimer = 10
export(int) var damageLevel:int = 1
export(float) var enemyMode = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = lifespanTimer
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if active:
		linear_velocity
	pass

func positionNow(locate:Vector2):
	position = locate
	pass

func runNow(velocite:Vector2):
#	apply_central_impulse(velocite * speed)
	linear_velocity = velocite * speed
	$Timer.start()
	pass

signal destroying()
func amDestroy():
	emit_signal("destroying")
	queue_free()
	pass

func _on_Timer_timeout():
	amDestroy()
	pass # Replace with function body.

func skinBullet(gambar:Texture):
	$Sprite.texture = gambar

func _on_TebengeBullet_body_entered(body):
	if body.is_in_group("Tebenge_Enemy") && !enemyMode:
		# Because on that Enemy (based on Player) already has Tebenge_Player, can't remove parent's group, we first check this Tebenge_Enemy group first.
		body.inflictDamage(damageLevel)
		queue_free()
		pass
	elif body.is_in_group("Tebenge_Player") && enemyMode:
		body.inflictDamage(damageLevel)
		queue_free()
		pass
	pass # Replace with function body.
