extends KinematicBody2D

class_name TebengePlayer

export(int) var playerNumber:int = 0 # Multiplayer number ID. from 0 to 3 or more idk.
export(int) var initHP:int = 3
export(bool) var initActivate:bool = false
export(bool) var cannotDie:bool = false
var lastHPBefore = 3
export(float) var speed:float = 5
var _pointRightNow:int = 0
var movening:Vector2 = Vector2(0,0)
var autoMovening:Vector2 = Vector2(0,0)
var excuseMeY:float = 0
var active:bool = false
var doingExcuseMe:bool = false
var momentaryInvincible:bool = false
var onTopAlready:bool = false
var haveGamepad:bool = false # is this player ID have Joypad ID connected?
export(float) var momentaryInvincibleDuration:float = 3
export (bool) var enemyMode:bool = false
export(bool) var movesToLeft:bool = false
export(PackedScene) var theBeluru = load("res://GameDVDCardtridge/Tebenge/SpareParts/TebengeBullet.tscn")
export(Texture) var bulletImage:Texture = load("res://GameDVDCardtridge/Tebenge/Assets/images/Beluru.png")
export(PackedScene) var theDuarParticle = load("res://GameDVDCardtridge/Tebenge/SpareParts/TebengeDuar.tscn")
export(Texture) var deathImage:Texture = load("res://GameDVDCardtridge/Tebenge/Assets/images/EikSerkat.png")
var hp:int = 3
var facingLeft:bool = false
export(float) var spaceBetweenBullet:float = 100
export(int) var maximumBullet:int = 5
export(int) var bulletDamage:int = 3
export(float) var autoShootPeriodTime = 6
export(ShaderMaterial) var reddenHuertMaterial = load("res://GameDVDCardtridge/Tebenge/Assets/shader/TebengeHuertShaderMaterial.tres")
var currentBulletOnScreen:int = 0
var arrayedBulletOnScreen:Array
var hasCollidenKinematic:KinematicCollision2D
export(AudioStream) var bulletCollisionSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/do-amarac.wav")
export(AudioStream) var huertSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/huert-keoust.wav")
export(AudioStream) var shootSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/tararot.wav")
export(AudioStream) var eikSerkatDuarSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/grefrhhruhumhumhmhm.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$GunShotSounder.stream = shootSound
	$HuertWoundeSounder.stream = huertSound
	var connecteh = Input.get_connected_joypads()
	Input.connect("joy_connection_changed",self,"_gamepadChange")
	haveGamepad = playerNumber in Input.get_connected_joypads()
	pass # Replace with function body.

func _enter_tree():
	reset(false)
	pass

func _gamepadChange(device:int=0,connected:bool=false):
	if device == playerNumber:
		haveGamepad = connected
	pass

func vibrateController(duration:float = 500,weakMagnitude:float = 1,strongMagnitude:float = 1):
#	Input.vibrate_handheld(duration)
#	if haveGamepad:
#		Input.start_joy_vibration(playerNumber,weakMagnitude,strongMagnitude,duration)
	Tebenge.vibrate(playerNumber,duration,weakMagnitude,strongMagnitude)
	pass

func stopVibrate():
#	if haveGamepad:
#		Input.stop_joy_vibration(playerNumber)
	Tebenge.stop_vibrate(playerNumber)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movening = Vector2(Input.get_axis("Tebenge_Kiri","Tebenge_Kanan"),Input.get_axis("Tebenge_Atas","Tebenge_Bawah"))
	excuseMeY = ((1 if movesToLeft else -1) * speed * 10) if doingExcuseMe else 0
	autoMovening = Vector2(speed * (-1 if movesToLeft else 1),excuseMeY)
	if active:
		if enemyMode:
			hasCollidenKinematic = move_and_collide(autoMovening,true)
			facingLeft = movesToLeft
			changeFace(movesToLeft)
			pass
			
			# TODO: check hp 0 then destroy
		else:
			if movening != Vector2.ZERO:
				hasCollidenKinematic = move_and_collide(movening*speed,true)
#				move_and_slide(movening * speed)
			
			if Input.is_action_just_pressed("Tebenge_Kiri"):
				changeFace(true)
			if Input.is_action_just_pressed("Tebenge_Kanan"):
				changeFace(false)
			
			if Input.is_action_just_pressed("Tebenge_Tembak"):
				# balan action abominationss
				shootNow()
	
	# pls help me get position relative to screen!!!
	if global_position.y < float(1080/2):
#		$FloatingHUD.position = $HUDBottomPos.position
#		$FloatingHUD.set_deferred("position",$HUDBottomPos.position)
#		$FloatingHUD.call_deferred("set_position",Vector2(0,$HUDBottomPos.position.y))
		if !enemyMode: # only bother if not enemy
			if !onTopAlready:
				$FloatingHUD.hide()
				$FloatingHUDBottom.show()
				onTopAlready = true
		pass
	else:
#		$FloatingHUD.position = $HUDTopPos.position
#		$FloatingHUD.set_deferred("position",$HUDTopPos.position)
#		$FloatingHUD.call_deferred("set_position",Vector2(0,$HUDTopPos.position.y))
		if !enemyMode:
			if onTopAlready:
				$FloatingHUD.show()
				$FloatingHUDBottom.hide()
				onTopAlready = false
		pass
	# bug! positional did not work well. it veer off to right.
	# use mirror Floating HUD instead!
	pass

func _physics_process(delta: float) -> void:
#	if hasCollidenKinematic:
#		var metadataing = hasCollidenKinematic.collider
#		if metadataing:
#			if metadataing.is_in_group("Tebenge_Enemy"):
#				if enemyMode:
##					doingExcuseMe = true
##					$ExcuseMeTimer.start(2)
##					position = Vector2(position.x + (-200 if movesToLeft else 200), position.y)
#					movesToLeft != movesToLeft
#					pass
#
	pass

func plsExcuseMe():
	doingExcuseMe = true
	$ExcuseMeTimer.start(.15)
	pass

func plsTurnAround():
	changeFace(!movesToLeft)
	pass

func reset(withResetTimer:bool = false):
	cannotDie = false
	hp = initHP
	arrayedBulletOnScreen.clear()
	$dedd.hide()
	$Form.show()
	$Collide.set_deferred("disabled", false)
	if withResetTimer:
		$DyingTimer.stop()
	set_active(initActivate,withResetTimer)
	_interpretHP()
	pass

func resurrect():
	reset(true)
#	set_active(true,true)

func set_active(itIs:bool = false, timerStart:bool = true):
	active = itIs
	if active:
		if enemyMode:
			if timerStart:
				$AutoShootPeriods.start(autoShootPeriodTime)
			pass
		pass
	else:
		$AutoShootPeriods.stop()
		pass
	pass

func shootNow():
	if arrayedBulletOnScreen.size() >= maximumBullet:
		return
	_spawnBullet()
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

func _checkWhoCollide(handover:Node):
	if handover.is_in_group("Tebenge_Enemy"):
		if enemyMode:
			plsExcuseMe()
			pass
		pass
	elif handover.is_in_group("Tebenge_Wall_Vertical"):
		if enemyMode:
			plsTurnAround()
			plsExcuseMe()
			pass
		pass
	pass

signal pointItIsNow(howMany)
func receivePoint(howMany:int,noVibrate:bool = false):
	if !noVibrate:
#		Input.vibrate_handheld(100)
		vibrateController(100)
	_pointRightNow += howMany
	$FloatingHUD.setPointsay(String(_pointRightNow))
	$FloatingHUDBottom.setPointsay(String(_pointRightNow))
	emit_signal("pointItIsNow", _pointRightNow)
	pass

func resetPoint():
	_pointRightNow = 0
	$FloatingHUD.setPointsay(String(_pointRightNow))
	$FloatingHUDBottom.setPointsay(String(_pointRightNow))
	emit_signal("pointItIsNow", _pointRightNow)
	pass

func getPoint() -> int:
	return _pointRightNow

func _reddens():
	var _tempModulate:Color = modulate
#	modulate = Color.red
#	reddenHuertMaterial.set_shader_param("redden",true)
	$Form.material.set_shader_param("redden",true)
	yield(get_tree().create_timer(.1),"timeout")
#	reddenHuertMaterial.set_shader_param("redden",false)
#	modulate = tempModulate
	$Form.material.set_shader_param("redden",false)
	pass

func _startInvincibleMomentarily():
	$MomentaryInvincibleTimer.start(momentaryInvincibleDuration)
	$InvincibleBlink.start(-1)
	momentaryInvincible = true
	pass

func _stoppedInvincibleMomentarily():
	$InvincibleBlink.stop()
	$Form.show()
	momentaryInvincible = false
	pass

func _toggleBlinkForm():
	$Form.visible = !$Form.visible
	pass

signal eikSerkat()
func _interpretHP():
	$FloatingHUD.setHPsay(String(hp))
	$FloatingHUDBottom.setHPsay(String(hp))
	if hp <= 0 && !cannotDie:
		# ded. Eik Serkat
		set_active(false)
		var duarInstance = theDuarParticle.instance()
		duarInstance.changeDuarSound(eikSerkatDuarSound)
		duarInstance.position = position
		get_parent().add_child(duarInstance,true)
		$DyingTimer.start(1)
#		hide()
#		$Form.texture = deathImage # why didnt show up?!
#		$Form.set_deferred("texture", deathImage) # NVM, DOESN'T WORK
		$Form.hide()
		$dedd.show() # screw this! I must make money because my parents gonna pension soon
		$Collide.set_deferred("disabled", true)
#		Input.vibrate_handheld(2000)
		vibrateController(2000)
		emit_signal("eikSerkat")
		pass
	else:
		if lastHPBefore > hp:
			# means lost hp
			# invinciblize momentarily
			_startInvincibleMomentarily()
			_reddens() #and red minecraft huert!
#			Input.vibrate_handheld(500)
			vibrateController(500)
			$HuertWoundeSounder.play()
			pass
		elif lastHPBefore < hp:
			# means add hp
			pass
		
		if cannotDie && hp < 1:
			hp = 1
			pass
		pass
	lastHPBefore = hp
	pass

func _spawnBullet():
	currentBulletOnScreen += 1
	var bullet = theBeluru.instance()
	arrayedBulletOnScreen.append(bullet)
	bullet.connect("destroying",self,"_bulletDestroyed")
	bullet.skinBullet(bulletImage)
	bullet.changeCollideSound(bulletCollisionSound)
	bullet.damageLevel = bulletDamage
	bullet.enemyMode = enemyMode
	bullet.ownering = self
	if facingLeft:
		pass
	else:
		pass
	bullet.positionNow(position + Vector2(spaceBetweenBullet * (-1 if facingLeft else 1),0))
	get_parent().add_child(bullet,true)
	$GunShotSounder.play()
	bullet.runNow(Vector2(-1 if facingLeft else 1,0))
	pass

func _bulletDestroyed(itself:Node, hitWho:Node, hitWhoRaw:Node):
	currentBulletOnScreen -= 1
	if currentBulletOnScreen < 0:
		currentBulletOnScreen = 0
	__removeBulletItself(itself)
	
	# which thing this bullet hit?
	if hitWho:
		if hitWho.is_in_group("Tebenge_Enemy"):
			if enemyMode:
				pass
			else:
				# want to use this "bug"?
				# to use this bug, let receive point even enem hp not <= 0
				if hitWho.hp <= 0:
					receivePoint(1)
				pass
			pass
		elif hitWho.is_in_group("Tebenge_Player") && !hitWho.is_in_group("Tebenge_Enemy"):
			pass
		elif hitWho.is_in_group("Tebenge_Bullet"):
			
			pass
	pass

func __removeBulletItself(handover):
	arrayedBulletOnScreen.erase(handover)

func inflictDamage(howMany:int):
	if !momentaryInvincible && howMany >= 0:
		hp -= howMany
		_interpretHP()
	pass

func addHP(howMany:int):
	if howMany >= 0:
		hp += howMany
		_interpretHP()
		pass
	pass

func _eikSerkat():
	_stoppedInvincibleMomentarily()
	hp = 0
	_interpretHP()
	pass

func _on_DyingTimer_timeout():
	if hp <= 0:
		if enemyMode:
			queue_free()
	pass # Replace with function body.

func _on_AutoShootPeriods_timeout():
	if enemyMode:
		_spawnBullet()
		pass
	pass # Replace with function body.

func _on_ExcuseMeTimer_timeout() -> void:
	doingExcuseMe = false
	pass # Replace with function body.

func _on_LeftSensorg_body_entered(body: Node) -> void:
	if movesToLeft:
		_checkWhoCollide(body)
	pass # Replace with function body.

func _on_RightSensorg_body_entered(body: Node) -> void:
	if !movesToLeft:
		_checkWhoCollide(body)
	pass # Replace with function body.


func _on_MomentaryInvincibleTimer_timeout() -> void:
	_stoppedInvincibleMomentarily()
	pass # Replace with function body.


func _on_InvincibleBlink_timeout() -> void:
	_toggleBlinkForm()
	pass # Replace with function body.
