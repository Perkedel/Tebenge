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

func receiveAskedContinue():
	hideAllODs()
	$ContinueOD.show()

func receiveContinueTick(with:int):
	pass

func _readyCustom() -> void:
	pass

func setContinueNumber(say:String) -> void:
	$ContinueOD/ContinueIndicatorDT.value


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
