extends RigidBody2D

var active:bool = false
export(float) var speed:float = 500
export(bool) var moves_wildly:bool = false
export(float) var lifespanTimer = 10
export(int) var damageLevel:int = 1
export(bool) var enemyMode:bool = false
export(bool) var itemMode:bool = false #item adds 2 score if not enemy, else -1 score
export(AudioStream) var collideSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/do-amarac.wav")
export(PackedScene) var sparkParticle:PackedScene = load("res://GameDVDCardtridge/Tebenge/SpareParts/BulletCrashed.tscn")
var iHitWhoRaw:Node
var iHitWhoSpecific:Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	$BulletCollideSound.stream = collideSound
	pass # Replace with function body.

func changeCollideSound(intoThis:AudioStream):
	$BulletCollideSound.stream = intoThis
	pass

func _enter_tree():
	$Timer.wait_time = lifespanTimer
	pass

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

func _spawnSpark():
	var particled = sparkParticle.instance()
	particled.position = position
	get_parent().add_child(particled,true)
	pass

signal destroying(myself)
func amDestroy():
	emit_signal("destroying",self,iHitWhoSpecific,iHitWhoRaw)
	queue_free()
	pass

func _on_Timer_timeout():
	amDestroy()
	pass # Replace with function body.

func skinBullet(gambar:Texture):
	$Sprite.texture = gambar

func _on_TebengeBullet_body_entered(body:Node):
	iHitWhoRaw = body
	if enemyMode:
		if body.is_in_group("Tebenge_Player") && !body.is_in_group("Tebenge_Enemy"):
			if itemMode:
				# victim get -1 point
				body.receivePoint(-1)
				pass
			else:
				body.inflictDamage(damageLevel)
			iHitWhoSpecific = body
			amDestroy()
			pass
		elif body.is_in_group("Tebenge_Enemy"):
			# hit by own bullet
			if itemMode:
				pass
			else:
				$BulletCollideSound.play()
				pass
			pass
		elif body.is_in_group("Tebenge_Bullet"):
			# enemy bullet bounces other enemy bullet but destroy player bullet & destroy itself
			if body.enemyMode:
				$BulletCollideSound.play()
				pass
			else:
				_spawnSpark()
				iHitWhoSpecific = body
				body.amDestroy()
				amDestroy()
			pass
		else:
			$BulletCollideSound.play()
			pass
	else:
		if body.is_in_group("Tebenge_Enemy"):
			# Because on that Enemy (based on Player) already has Tebenge_Player, can't remove parent's group, we first check this Tebenge_Enemy group first.
			if itemMode:
				# uh, maybe steal HP from the victim, and put it to bullet owner?
				# yess, vampire!
				pass
			else:
				body.inflictDamage(damageLevel)
			iHitWhoSpecific = body
			amDestroy()
			pass
		elif body.is_in_group("Tebenge_Player") && !body.is_in_group("Tebenge_Enemy"):
			# when hit by own bullet / took item
			if itemMode:
				# add the body 2 point
				body.receivePoint(2)
				iHitWhoSpecific = body
				amDestroy()
				pass
			else:
				$BulletCollideSound.play()
				pass
			# no don't destroy!
			pass
		elif body.is_in_group("Tebenge_Bullet"):
			# player bullet bounces player bullet but destroy enemy bullet & destroy itself
			if body.enemyMode:
				_spawnSpark()
				iHitWhoSpecific = body
				body.amDestroy()
				amDestroy()
				pass
			else:
				$BulletCollideSound.play()
				pass
			pass
		else:
			$BulletCollideSound.play()
			pass
	pass # Replace with function body.
