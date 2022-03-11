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

func mainMenuPls():
	$MenuLagrange.show()
	$GameplayLagrange.hide()
	$MenuLagrange.mainMenuPls()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setContinueNumber(say:String):
	$GameplayLagrange.setContinueNumber(say)
	pass

signal uiWantsTo(nameOf,fromOD, fromLagrange)

func _on_MenuLagrange_LagrangeWantsTo(nameOf:String,fromOD:String, fromLagrange:String):
	print("UI wants to %s from OD %s Lagrange %s" % [nameOf, fromOD, fromLagrange])
	emit_signal("uiWantsTo",nameOf,fromOD,fromLagrange)
	pass # Replace with function body.


func _on_GameplayLangrange_LagrangeWantsTo(nameOf, fromOD, fromLagrange):
	pass # Replace with function body.
