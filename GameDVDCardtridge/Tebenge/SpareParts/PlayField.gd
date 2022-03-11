extends Node2D

class_name TebengePlayField

enum gameModes{Arcade,Endless}
export(gameModes) var chooseGameMode
export(NodePath) var PlayerThemselves:NodePath  #= get_node("TebengePlayer") # bug! it fails to compile!
export(bool) var active:bool = false
export(bool) var spawnOnLeft = false
export(float) var spawnEvery:float = 3
export(bool) var preActivateTest:bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var Enemy:PackedScene = load("res://GameDVDCardtridge/Tebenge/SpareParts/TebengeEnemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _enter_tree():
	$TebengePlayer.initActivate = preActivateTest
	set_active(preActivateTest)
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
#		$NewSpawnTimer.start(spawnEvery)
		pass
	else:
		$NewSpawnTimer.stop()
		for thingye in get_children():
			if thingye.is_in_group("Tebenge_Enemy"):
				thingye.set_active(false)
				pass
			pass
	pass

func resetPlayfield():
	despawnEnemies()
#	PlayerThemselves.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	$TebengePlayer.reset()
	$TebengePlayer.position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	pass

func _enemyDown():
	#add score
	pass

signal game_over()
signal game_finish()
func _youDied():
	set_active(false)
	emit_signal("game_over")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	pass # Replace with function body.
