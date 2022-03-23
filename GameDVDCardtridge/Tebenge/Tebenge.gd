extends Node

const savePath:String = "user://Simpan/Tebenge/Simpan.json"
var _saveTemplate:Dictionary = {
	kludgeHiScore = {
		arcade = 0,
		endless = 0,
	},
	saveState = {
		arcade = {},
		endless = {},
	}
}
signal ChangeDVD_Exec()
signal Shutdown_Exec()
signal AdInterstitial_Exec()
signal AdRewarded_Exec()
signal AdBanner_Exec()
export(TebengePlayField.gameModes) var gameMode = TebengePlayField.gameModes.Arcade
export(float) var arcadeTimeLimit = 120
export(AudioStream) var pauseSound = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/PauseOpen.wav")
export(AudioStream) var unpauseSound = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/PauseClose.wav")
onready var loadedHexagonEngine:bool = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var saveDictionary:Dictionary = {
	
}
var wantsToContinue:bool = false
var youveGotNewHiScore:bool = false
var kludgeHiScoreArcade:int = 0 # Highest number of kill
var kludgeHiScoreEndless:int = 0
var _anyKludgeHiScoreRightNow:int = 0
var _pointRightNow:int = 0 setget set_point_right_now
var _multiPointRightNow:PoolIntArray = [0,0,0,0]
var ticket:int = 0 # how many ticket rewarded. in Casino, it is chip $1

func _loadSave():
	#load JSON
	var thing:File = File.new()
#	thing.open(savePath,_File.WRITE_READ)
	if thing.file_exists(savePath):
		#file exist
		thing.open(savePath,File.READ)
		saveDictionary = parse_json(thing.get_as_text())
		thing.close()
		# inject data
		kludgeHiScoreArcade = saveDictionary["kludgeHiScore"]["arcade"]
		kludgeHiScoreEndless = saveDictionary["kludgeHiScore"]["endless"]
		pass
	else:
		#file not exist
		saveDictionary = _saveTemplate
		_saveSave()
		pass
	# then inject data to here
	
#	_interpresHiScore()
	pass

func _saveSave():
	# fill dictionary first!
	saveDictionary["kludgeHiScore"]["arcade"] = kludgeHiScoreArcade
	saveDictionary["kludgeHiScore"]["endless"] = kludgeHiScoreEndless
	
	var thing:File = File.new()
	thing.open(savePath,File.WRITE_READ)
	
	# beautify JSON then store string!
	var ingredient:String = JSONBeautifier.beautify_json(to_json(saveDictionary))
	thing.store_string(ingredient)
	
	thing.close()
	_interpresHiScore()
	pass

func _init() -> void:
	_loadSave()
	if !Engine.has_singleton("TebengeGlobals"):
		# add singleton only exist for Editor plugin
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_interpresHiScore()
	pass # Replace with function body.

func _enter_tree():
	
	pass

func _mainMenuPls():
	$CanvasLayer/UIField.mainMenuPls()
	pass

func _settingPls(inGame:bool = false):
	$CanvasLayer/UIField.settingPls(inGame)
	pass

func _attemptAbortGame():
	if get_tree().paused:
		pass
	else:
		get_tree().paused = true
		pass
	$CanvasLayer/UIField.attemptAbortGame()
	pass

func _confirmedAbortGame(itIs:bool = false):
	if itIs:
		$PlayField.cancelTheGame()
		pass
	else:
		$CanvasLayer/UIField.pauseTheGame(true)
		pass
	_interpresHiScore()
	pass

func _resetAfterGameDone():
	youveGotNewHiScore = false
	_mainMenuPls()
	$PlayField.resetPlayfield()
	#add reset function
	pass

func _intoGameMode():
	$CanvasLayer/UIField.intoGameMode()
	pass

func _startTheGame(withMode = TebengePlayField.gameModes.Arcade):
	print("Start the game with mode %s" % [String(withMode)])
#	if typeof(withMode) != TebengePlayField.gameModes:
#		return
	
	gameMode = withMode
#	$PlayField.chooseGameMode = withMode
	$PlayField.startTheGame(withMode)
	$CanvasLayer/UIField.startTheGame(withMode)
	_interpresHiScore()
	pass

func _pauseTheGame(pauseIt:bool = false):
	$PlayField.pauseTheGame(pauseIt)
	$CanvasLayer/UIField.pauseTheGame(pauseIt)
	pass

func set_point_right_now(howMany:int):
#	if $PlayField.gameplayStarted:
	_pointRightNow = howMany
	# ticket = floor (point / 10)
	ticket = floor(_pointRightNow/10)
	# don't be but hole by not give ticket even gamer paid a dime
	# and lose under 10 points!
	if ticket < 1:
		ticket = 1
	
	$CanvasLayer/UIField.setGameOverTickeySay("Tickets %d" % [ticket])
	_interpresHiScore()
#	print("Point %d" % [howMany])
	pass

func _interpresHiScore():
	match(gameMode):
		TebengePlayField.gameModes.Arcade:
			if _pointRightNow > kludgeHiScoreArcade:
				youveGotNewHiScore = true
				kludgeHiScoreArcade = _pointRightNow
				_anyKludgeHiScoreRightNow = _pointRightNow
			else:
#				youveGotNewHiScore = false
				_anyKludgeHiScoreRightNow = kludgeHiScoreArcade
				pass
			pass
		TebengePlayField.gameModes.Endless:
			if _pointRightNow > kludgeHiScoreEndless:
				youveGotNewHiScore = true
				kludgeHiScoreEndless = _pointRightNow
				_anyKludgeHiScoreRightNow = _pointRightNow
			else:
#				youveGotNewHiScore = false
				_anyKludgeHiScoreRightNow = kludgeHiScoreEndless
				pass
			pass
		_:
			pass
	
	$CanvasLayer/UIField.gotNewHiScore(youveGotNewHiScore, _anyKludgeHiScoreRightNow)
	$CanvasLayer/UIField.updateKludgeHiScores(kludgeHiScoreArcade,kludgeHiScoreEndless)
	
	if youveGotNewHiScore:
#		print("New hi score")
		pass
	else:
#		print(" no new hiscore")
		pass
	pass

func _receiveAskedContinue():
	
	$CanvasLayer/UIField.receiveAskedContinue()
	pass

func _receiveContinueTick(itSays:int):
	$CanvasLayer/UIField.receiveContinueTick(itSays) #unused. we use set continue say instead idk.
	setContinueNumber(String(itSays))
	pass

func _receiveArcadeTimer(itSays:float):
	$CanvasLayer/UIField.receiveArcadeTimer(itSays)
	pass

func _receiveEndlessTimer(itSays:float):
	$CanvasLayer/UIField.receiveEndlessTimer(itSays)
	pass

func _receiveGameDone(didIt:bool = false):
	$CanvasLayer/UIField.receiveGameDone(didIt)
	# game has been done!
	if didIt:
		# Game Finish
		pass
	else:
		# Game Over
		pass
	
	# other things too
	# Highscore!
	_interpresHiScore()
	
	# finally, totally save.
	_saveSave()
	pass

func _appearAdVideoTron(rewarded:bool = false):
	#Philosophically, you are not allowed to integrate appear ad in functions!
	#You may integrate this containing function inside another functions though.
	emit_signal("AdRewarded_Exec" if rewarded else "AdInterstitial_Exec")
	pass

func _iWantToContinue(wantIt:bool = true):
	wantsToContinue = true
	if wantIt:
		# play ad if there is one.
		if OS.get_name() == "Android":
			if Engine.has_singleton("GodotAdmob"):
				# random chance this would spawn either regular interstitial or rewarded unskipable
				var chance:float = rand_range(0,100)
				_appearAdVideoTron(false if chance > 50.0 else true)
			else:
				print("Admob Java singleton not found! that's okay. We hate ads too. just.. financial issues")
				_frigginCheckContinue(wantIt)
		else:
			print("Not android. no ad support. no money. it's okay, you can just go")
			_frigginCheckContinue(wantIt)
	else:
		print("doesn't want to continue")
		_frigginCheckContinue(wantIt)
	pass

func _frigginCheckContinue(chosenContinue:bool = true):
	if wantsToContinue:
		# continue game. check if credit inserted is there.
		$PlayField.selectedAContinue(chosenContinue)
		$CanvasLayer/UIField.selectedAContinue(chosenContinue)
		wantsToContinue = false
#	if chosenContinue:
#
#	else:
#		$PlayField.selectedAContinue(false)
#		$CanvasLayer/UIField.selectedAContinue(false)
#		wantsToContinue = false
	pass

func setContinueNumber(say:String)->void:
	$CanvasLayer/UIField.setContinueNumber(say)

func readUISignalWantsTo(nameToDo:String, ODNameOf:String,lagrangeNameOf:String):
	print("This UI wants to %s from OD %s & Lagrange %s" % [nameToDo, ODNameOf, lagrangeNameOf])
	match(lagrangeNameOf):
		"MenuLagrange":
			match(ODNameOf):
				"MainMenuOD":
					match(nameToDo):
						"Play":
							print("Less go!!")
							_intoGameMode()
							pass
						"Setting":
							print("Settingeh")
							_settingPls()
							pass
						"Exit":
							print("Haah?!")
							pass
						_:
							pass
					pass
				"SettingOD":
					match(nameToDo):
						"Back":
							_mainMenuPls()
							pass
						_:
							pass
					pass
				"QuitDialogOD":
					match(nameToDo):
						"Shutdown":
							print("Noooo!")
							_terminateThisDVD(false)
							pass
						"ChangeDVD":
							print("Oh nooo!!!")
							_terminateThisDVD(true)
							pass
						"Cancel":
							print("Whew")
							_mainMenuPls()
							pass
						_:
							pass
					pass
				_:
					pass
			pass
		"GameplayLagrange":
			match(ODNameOf):
				"ModesOD":
					match(nameToDo):
						"Arcade":
							_startTheGame(TebengePlayField.gameModes.Arcade)
							pass
						"Endless":
							_startTheGame(TebengePlayField.gameModes.Endless)
							pass
						"Back":
							_mainMenuPls()
							pass
					pass
				"HUDOD":
					match(nameToDo):
						"Pause":
#							_pauseTheGame()
							pauseNow(true)
							pass
						_:
							pass
					pass
				"PauseOD":
					match(nameToDo):
						"Resume":
							pauseNow(false)
							pass
						"Setting":
							_settingPls(true)
							pass
						"Quit":
							_attemptAbortGame()
							pass
						_:
							pass
					pass
				"SettingOD":
					match(nameToDo):
						"Back":
							_pauseTheGame(true)
							pass
						_:
							pass
					pass
				"AbortDialogOD":
					match(nameToDo):
						"Yes":
							_confirmedAbortGame(true)
							pass
						"No":
							_confirmedAbortGame(false)
							pass
						_:
							pass
					pass
				"ContinueOD":
					match(nameToDo):
						"YES":
							# continue game (arcade only)
							_iWantToContinue(true)
							pass
						"NO":
							_iWantToContinue(false)
							# game over
							pass
						_:
							pass
					pass
				"GameOverOD":
					match(nameToDo):
						"Back":
							_resetAfterGameDone()
							_appearAdVideoTron(false)
							pass
						_:
							pass
				_:
					pass
			pass
		_:
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _terminateThisDVD(changeDVD:bool = false):
	_saveSave()
	if changeDVD:
		emit_signal("ChangeDVD_Exec")
	else:
		emit_signal("Shutdown_Exec")
	pass

func pauseNow(isIt:bool = false):
#	pause_mode = isIt
#	get_tree().paused = isIt
	if isIt:
		$InternalSpeaker.stream = pauseSound
		pass
	else:
		$InternalSpeaker.stream = unpauseSound
		pass
	$InternalSpeaker.play()
	_pauseTheGame(isIt)

func _on_UIField_uiWantsTo(nameOf:String, fromOD:String, fromLagrange:String):
	readUISignalWantsTo(nameOf, fromOD,fromLagrange)
	pass # Replace with function body.

func _on_PlayField_game_over() -> void:
	_receiveGameDone(false)
	pass # Replace with function body.


func _on_UIField_wantsToPlay() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToQuit() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToShutdown() -> void:
	pass # Replace with function body.

func receive_AdInterstitial_success() -> void:
	_frigginCheckContinue(true)
	pass

func receive_AdInterstitial_closed() -> void:
	pass

func receive_AdInterstitial_failed() -> void:
	_frigginCheckContinue(true)
	pass

func receive_AdRewarded_success() -> void:
	_frigginCheckContinue(true)
	pass

func receive_AdRewarded_failed() -> void:
	# dont be buthole
	_frigginCheckContinue(true)
	pass

func receive_AdBanner_success() -> void:
	
	pass

func receive_AdBanner_failed() -> void:
	# DO NOT LIMIT ANYTHING JUST BECAUSE THIS BANNER FAIL TO LOAD!!!
	pass

func _on_PlayField_askedContinue() -> void:
	_receiveAskedContinue()
	pass # Replace with function body.


func _on_PlayField_continueCountdownTicked(remaining:int) -> void:
	# remaining Int
	_receiveContinueTick(remaining)
	pass # Replace with function body.

func _on_PlayField_pointItIsNow(howMany:int,thatsForPlayer:int = 0) -> void:
#	_pointRightNow = howMany
	set_point_right_now(howMany)
	_multiPointRightNow[thatsForPlayer] = howMany
	pass # Replace with function body.

func _on_PlayField_continuousArcadeTimer(timeSecond:float) -> void:
#	_receiveArcadeTimer(timeSecond)
	pass # Replace with function body.

func _on_PlayField_game_finish() -> void:
	_receiveGameDone(true)
	pass # Replace with function body.


func _on_PlayField_tickedArcadeTimer(timeSecond:float) -> void:
#	print("Time left %d" % [timeSecond])
	_receiveArcadeTimer(timeSecond)
	pass # Replace with function body.


func _on_PlayField_continuousEndlessTimer(timeSecond) -> void:
#	_receiveEndlessTimer(timeSecond)
	pass # Replace with function body.


func _on_PlayField_tickedEndlessTimer(timeSecond) -> void:
	_receiveEndlessTimer(timeSecond)
	pass # Replace with function body.
