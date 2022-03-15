extends Control

signal wantsToPlay
signal wantsToQuit
signal wantsToShutdown
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _hideAllLagranges():
	for these in get_children():
		if these is BaseLagrange:
			these.hide()

func mainMenuPls():
	_hideAllLagranges()
#	$GameplayLagrange.hide()
	$MenuLagrange.show()
	$MenuLagrange.mainMenuPls()
	pass

func intoGameMode():
	_hideAllLagranges()
#	$MenuLagrange.hide()
	$GameplayLagrange.show()
	$GameplayLagrange.intoGameMode()
	pass

func startTheGame(withMode):
	$GameplayLagrange.startTheGame(withMode)
	pass

func receiveAskedContinue():
	_hideAllLagranges()
	$GameplayLagrange.show()
	$GameplayLagrange.receiveAskedContinue()
	pass

func receiveContinueTick(with:int):
	$GameplayLagrange.receiveContinueTick(with)
	pass

func receiveArcadeTimer(with:float):
	$GameplayLagrange.receiveArcadeTimer(with)
	pass

func receiveGameDone(didIt:bool = false):
	$GameplayLagrange.receiveGameDone(didIt)
	pass

func pauseTheGame(pauseIt:bool = false):
	_hideAllLagranges()
#	$MenuLagrange.hide()
	$GameplayLagrange.show()
	$GameplayLagrange.pauseTheGame(pauseIt)
	pass

func selectedAContinue(saidYes:bool):
	_hideAllLagranges()
	$GameplayLagrange.show()
	$GameplayLagrange.selectedAContinue(saidYes)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setContinueNumber(say:String):
	$GameplayLagrange.setContinueNumber(say)
	pass

func setGameOverTickeySay(say:String):
	$GameplayLagrange.setGameOverTicketSay(say)

signal uiWantsTo(nameOf,fromOD, fromLagrange)

func _on_MenuLagrange_LagrangeWantsTo(nameOf:String,fromOD:String, fromLagrange:String):
	print("UI wants to %s from OD %s Lagrange %s" % [nameOf, fromOD, fromLagrange])
	emit_signal("uiWantsTo",nameOf,fromOD,fromLagrange)
	pass # Replace with function body.


func _on_GameplayLangrange_LagrangeWantsTo(nameOf, fromOD, fromLagrange):
	print("UI wants to %s from OD %s Lagrange %s" % [nameOf, fromOD, fromLagrange])
	emit_signal("uiWantsTo",nameOf,fromOD,fromLagrange)
	pass # Replace with function body.
