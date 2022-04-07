extends BaseLagrange

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.

func intoGameMode() -> void:
	hideAllODs()
	$ModesOD.show()
	pass

func settingPls():
	hideAllODs()
	$SettingOD.show()
	pass

func openGooglePlayOd():
	hideAllODs()
	$GooglePlayOD.show()
	pass

func attemptAbortGame():
	hideAllODs()
	$AbortDialogOD.show()
	pass

func startTheGame(withMode):
	hideAllODs()
	$HUDOD.show()
	pass

func pauseTheGame(pauseIt:bool = false) -> void:
	hideAllODs()
	if pauseIt:
		$PauseOD.show()
	else:
		$HUDOD.show()
	pass

func gotNewHiScore(isIt:bool = false, score:int = 0, gameMode:String = ""):
	$GameOverOD/HiScoreDT.title = (gameMode) + " " + ("NEW High Score!!!" if isIt else "HighScore")
	$GameOverOD/HiScoreDT.value = String(score)
	$PauseOD/HiScoreDT.title = (gameMode) + " " + ("NEW High Score!!!" if isIt else "HighScore")
	$PauseOD/HiScoreDT.value = String(score)
	$HUDOD/HiScoreDT.title = (gameMode) + " " + ("NEW High Score!!!" if isIt else "HighScore")
	$HUDOD/HiScoreDT.value = String(score)
	pass

func updateKludgeHiScores(arcadeOne:int = 0, endlessOne:int = 0):
	$ModesOD/ArcadeHiScoreDT.value = String(arcadeOne)
	$ModesOD/EndlessHiScoreDT.value = String(endlessOne)
	pass

func receiveAskedContinue():
	hideAllODs()
	$ContinueOD.show()

func receiveContinueTick(with:int):
	$ContinueOD.receiveContinueTick(with)
	pass

func receiveArcadeTimer(with:float):
	$HUDOD/ArcadeTimeRemainingDT.title = "Time remaining"
	$HUDOD/ArcadeTimeRemainingDT.value = String(int(with)) + " Seconds"
	$PauseOD/TimeRemainingDT.title = "Time remaining"
	$PauseOD/TimeRemainingDT.value = String(int(with)) + " Seconds"
	pass

func receiveEndlessTimer(with:float):
	$HUDOD/ArcadeTimeRemainingDT.title = "Time elapsed"
	$HUDOD/ArcadeTimeRemainingDT.value = String(int(with)) + " Seconds"
	$PauseOD/TimeRemainingDT.title = "Time elapsed"
	$PauseOD/TimeRemainingDT.value = String(int(with)) + " Seconds"
	pass

func receiveGameDone(didIt:bool):
	hideAllODs()
	if didIt:
		$GameOverOD/GameOverDT.title = "Game FINISH"
	else:
		$GameOverOD/GameOverDT.title = "Game OVER"
	$GameOverOD.show()
	pass

func _readyCustom() -> void:
	pass

func selectedAContinue(saidYes:bool = false):
#	hideAllODs()
	if saidYes:
		hideAllODs()
		$HUDOD.show()
		pass
	else:
#		$GameOverOD.show() # let this alone?
#		receiveGameDone(false)
		pass
	pass

func setContinueNumber(say:String) -> void:
	# damn! too late, I already decided to edit its children instead.
	$ContinueOD/ContinueIndicatorDT.value = say

func setGameOverTicketSay(say:String) -> void:
	$GameOverOD/GameOverDT.value = say

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
