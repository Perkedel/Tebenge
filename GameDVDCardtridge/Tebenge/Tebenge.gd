extends Node

signal ChangeDVD_Exec()
signal Shutdown_Exec()
signal AdInterstitial_Exec()
signal AdRewarded_Exec()
signal AdBanner_Exec()
export(TebengePlayField.gameModes) var gameMode = TebengePlayField.gameModes.Arcade
onready var loadedHexagonEngine:bool = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wantsToContinue:bool = false

func _init() -> void:
	if !Engine.has_singleton("TebengeGlobals"):
		# add singleton only exist for Editor plugin
		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	
	pass

func _mainMenuPls():
	$CanvasLayer/UIField.mainMenuPls()
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
	pass

func _pauseTheGame(pauseIt:bool = false):
	$PlayField.pauseTheGame(pauseIt)
	$CanvasLayer/UIField.pauseTheGame(pauseIt)
	pass

func _receiveAskedContinue():
	
	$CanvasLayer/UIField.receiveAskedContinue()
	pass

func _receiveContinueTick(itSays:int):
	$CanvasLayer/UIField.receiveContinueTick(itSays) #unused. we use set continue say instead idk.
	setContinueNumber(String(itSays))
	pass

func _iWantToContinue(wantIt:bool = true):
	if wantIt:
		wantsToContinue = true
		# play ad if there is one.
		if Engine.has_singleton("GodotAdmob"):
			# random chance this would spawn either regular interstitial or rewarded unskipable
			var chance:float = rand_range(0,100)
			if chance > 50.0:
				emit_signal("AdInterstitial_Exec")
			else:
				emit_signal("AdRewarded_Exec")
			pass
		else:
			print("Admob Java singleton not found! that's okay. We hate ads too. just.. financial issues")
			_frigginCheckContinue()
	pass

func _frigginCheckContinue(chosenContinue:bool = true):
	if chosenContinue:
		if wantsToContinue:
			# continue game. check if credit inserted is there.
			$PlayField.selectedAContinue(true)
			
			wantsToContinue = false
	else:
		$PlayField.selectedAContinue(false)
		wantsToContinue = false
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
							pass
						"Exit":
							print("Haah?!")
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
							_pauseTheGame()
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
	if changeDVD:
		emit_signal("ChangeDVD_Exec")
	else:
		emit_signal("Shutdown_Exec")
	pass

func pauseNow(isIt:bool = false):
	pause_mode = isIt
	if isIt:
		pass
	else:
		pass

func _on_UIField_uiWantsTo(nameOf:String, fromOD:String, fromLagrange:String):
	readUISignalWantsTo(nameOf, fromOD,fromLagrange)
	pass # Replace with function body.

func _on_PlayField_game_over() -> void:
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
