extends Node2D

class_name TebengePlayField

enum gameModes{Arcade,Endless}
export(gameModes) var chooseGameMode
export(NodePath) var PlayerThemselves:NodePath  #= get_node("TebengePlayer") # bug! it fails to compile!
export(bool) var active:bool = false #setget set_active
export(bool) var spawnOnLeft = false
export(float) var spawnEvery:float = 3
export(bool) var preActivateTest:bool = false
export(float) var arcadePlayTimeLimit = 120
export(float) var bonusMomentTimeLimit = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var Enemy:PackedScene = load("res://GameDVDCardtridge/Tebenge/SpareParts/TebengeEnemy.tscn")
export(PackedScene) var BonusBullet:PackedScene = load("res://GameDVDCardtridge/Tebenge/SpareParts/TebengeBulletBonus.tscn")
var arcadeTimeLeft:float = 120
var isPaused:bool = false
var last_placed_position:Vector2 = Vector2(0,0)
var gameplayStarted:bool = false
var continueThreat:bool = false # whether or not you are in continue screen
var continueRemaining:int = 10
signal continuousArcadeTimer(timeSecond)
signal tickedArcadeTimer(timeSecond)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_placed_position = $TebengePlayer.position
#	$ArcadeTimeoutTimer
	pass # Replace with function body.

func _init() -> void:
	pass

func startTheGame(withMode = gameModes.Arcade) -> void:
	
	chooseGameMode = withMode
	arcadeTimeLeft = arcadePlayTimeLimit
	match(chooseGameMode):
		gameModes.Arcade:
			$ArcadeTimeoutTimer.start(arcadePlayTimeLimit)
			$ArcadeTickoutTimer.start(1)
			pass
		gameModes.Endless:
			pass
		_:
			pass
	set_active(true)
	print("Let's begin! " + String(withMode))
	gameplayStarted = true
	pass

func finishTheGame(didIt:bool = false) -> void:
	if didIt:
		# game finish
		emit_signal("game_finish")
		pass
	else:
		# game over
		emit_signal("game_over")
		pass
	set_active(false)
	$ArcadeTimeoutTimer.stop()
	$ArcadeTickoutTimer.stop()
	gameplayStarted = false

func cancelTheGame() -> void:
	
	gameplayStarted = false
	pass

func pauseTheGame(pauseIt:bool = false) -> void:
	get_tree().paused = pauseIt
	if pauseIt:
		pass
	else:
		pass
	pass

signal askedContinue()
func askContinue():
	set_active(false)
	if chooseGameMode == gameModes.Arcade:
		_startContinueFate(true)
		emit_signal("askedContinue")
	else:
		emit_signal("game_over")
	pass

func selectedAContinue(saidYes:bool = false):
	if saidYes:
		# clicked YES
		$TebengePlayer.resurrect()
		set_active(true)
		pass
	else:
		# clicked NO
		set_active(false)
		finishTheGame(false)
		pass
	
	_startContinueFate(false)
	pass

func _enter_tree() -> void:
	$TebengePlayer.initActivate = preActivateTest
	set_active(preActivateTest)
	pass

func arcadeTimerLeft(left:float):
	emit_signal("continuousArcadeTimer",left)
	emit_signal("tickedArcadeTimer",left)
	
	if left <= 0:
		arcadeTimeHasRanOut()
		pass
	pass

func arcadeTimeHasRanOut():
	# grab every enemy positions, destroy them, spawn bonus coin at that position.
	# all of them. 10 second to grab bonuses.
	if chooseGameMode == gameModes.Arcade:
		$NewSpawnTimer.stop()
		$ArcadeTickoutTimer.stop()
		
		sulapEnemiesIntoBonus()
		
		$BonusTimerLimit.start(bonusMomentTimeLimit)
	pass

func bonusTimeHasRanOut():
	# immediately game finish
	finishTheGame(true)
	pass

func spawnEnemy():
	var instanceEnemy = Enemy.instance()
	instanceEnemy.active = true
	instanceEnemy.movesToLeft = !spawnOnLeft
	instanceEnemy.position = Vector2(0 if spawnOnLeft else get_viewport().size.x, rand_range(0, get_viewport().size.y))
	spawnOnLeft = !spawnOnLeft
	instanceEnemy.connect("eikSerkat",self,"_on_everyEnemyEikSerkat")
	add_child(instanceEnemy)
	pass

func despawnEnemies():
	for thingye in get_children():
		if thingye.is_in_group("Tebenge_Enemy"):
			thingye.queue_free()
		pass
	pass

func sulapEnemiesIntoBonus():
	for thingye in get_children():
		var positional:Vector2
		var instanceBonus:Node
		if thingye.is_in_group("Tebenge_Enemy"):
			positional = thingye.position
			instanceBonus = BonusBullet.instance()
			thingye._eikSerkat()
			# optional: we could've add point per enemy converted like we killed them. idk.
			instanceBonus.position = positional
			add_child(instanceBonus)
		pass
	pass

func turnEnemiesIntoBonus():
	# same as above but this time this also put bonus coins in position of where enemy was
	for thingye in get_children():
		if thingye.is_in_group("Tebenge_Enemy"):
			# add coin to enemy position
			thingye.queue_free()
			pass
	pass

func set_active(itIs:bool = false):
	active = itIs
	$TebengePlayer.set_active(itIs)
	if active:
#		$NewSpawnTimer.paused = false
		$NewSpawnTimer.start(spawnEvery)
		$ArcadeTimeoutTimer.paused = false
		$ArcadeTickoutTimer.paused = false
		for thingye in get_children():
			if thingye.is_in_group("Tebenge_Enemy"):
				thingye.set_active(true)
			pass
		pass
	else:
#		$NewSpawnTimer.paused = true
		$NewSpawnTimer.stop()
		$ArcadeTimeoutTimer.paused = true
		$ArcadeTickoutTimer.paused = true
		for thingye in get_children():
			if thingye.is_in_group("Tebenge_Enemy"):
				thingye.set_active(false)
				pass
			pass
	pass

func resetPlayfield(continueIt:bool = false):
	$TebengePlayer.reset()
	despawnEnemies()
	$TebengePlayer.resetPoint()
#	PlayerThemselves.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
#	$TebengePlayer.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	$TebengePlayer.position = last_placed_position
	pass

func _enemyDown():
	#add score
	pass

signal game_over()
signal game_finish()
func _youDied():
#	set_active(false)
#	emit_signal("game_over")
	# first, continue countdown!
	askContinue()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
#		emit_signal("continuousArcadeTimer",$ArcadeTimeoutTimer.time_left)
#		arcadeTimerLeft($ArcadeTimeoutTimer.time_left)
		pass
	pass

func _startContinueFate(startIt:bool = false):
	continueThreat = startIt
	
	if startIt:
		$ContinueTickCountdown.start(1)
	else:
		$ContinueTickCountdown.stop()
	pass

signal continueCountdownTicked(remaining) #remaining int
func _tickContinueCountdown():
	# every 1 second this timeouts, tick the countdown -1 of continue timer.
	# 10 9 8 7 6 5 4 3 2 1 game over!
	continueRemaining -= 1
	
	if continueRemaining > 0:
		# quick press yes!
		pass
	else:
		# time's up game over
		finishTheGame(false)
		pass
	
	emit_signal("continueCountdownTicked", continueRemaining)
	pass

func _on_NewSpawnTimer_timeout():
	spawnEnemy()
	pass # Replace with function body.

func _on_TebengePlayer_eikSerkat():
	_youDied()
	pass # Replace with function body.

func _on_everyEnemyEikSerkat():
	_enemyDown()
	pass

func _on_ArcadeTimeoutTimer_timeout() -> void:
	# no more enemy, spawn bonus pickups!
#	arcadeTimeHasRanOut()
	pass # Replace with function body.

func _on_BonusTimerLimit_timeout() -> void:
	bonusTimeHasRanOut()
	pass # Replace with function body.

func _on_ContinueTickCountdown_timeout() -> void:
	# every 1 second this timeouts, tick the countdown -1 of continue timer.
	# 10 9 8 7 6 5 4 3 2 1 game over!
	_tickContinueCountdown()
	pass # Replace with function body.

signal pointItIsNow(howMany, thatsForPlayer)
func _on_TebengePlayer_pointItIsNow(howMany:int) -> void:
	emit_signal("pointItIsNow",howMany,0)
	pass # Replace with function body.

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		isPaused = true
		pass
	elif what == NOTIFICATION_UNPAUSED:
		isPaused = false
	pass

func _on_ArcadeTickoutTimer_timeout() -> void:
#	print("tick arcade %d" % [arcadeTimeLeft])
#	emit_signal("tickedArcadeTimer", $ArcadeTimeoutTimer.time_left)
	if active && chooseGameMode == gameModes.Arcade:
		arcadeTimeLeft -= 1
		arcadeTimerLeft(arcadeTimeLeft)
	pass # Replace with function body.
