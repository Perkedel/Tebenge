extends BaseLagrange


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func mainMenuPls():
	hideAllODs()
	$MainMenuOD.show()
#	$QuitDialogOD.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _receiveOdeePressOption(named:String,fromOD:String, fromLagrangeOf:String):
	print("weha")
	match(fromOD):
		"MainMenuOD":
			print("You selected %s" % [named])
			match(named):
				"Play":
					pass
				"Setting":
					pass
				"Exit":
					$MainMenuOD.hide()
					$QuitDialogOD.show()
					pass
				_:
					pass
		"QuitDialogOD":
			print("Fated to %s" % [named])
			match(named):
				"Shutdown":
					pass
				"ChangeDVD":
					pass
				"Cancel":
					mainMenuPls()
					pass
				_:
					pass
					
		_:
			pass
	emit_signal("LagrangeWantsTo",named,fromOD,fromLagrangeOf)
	pass

func _on_MainMenuOD_pressedOption(nameOf, oDName):
	pass # Replace with function body.
