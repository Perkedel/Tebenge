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

func settingPls():
	hideAllODs()
	$SettingOD.show()
	pass

func quitPls():
	hideAllODs()
	$QuitDialogOD.show()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func gotNewHiScore(isIt:bool = false, score:int = 0):
	pass

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
					quitPls()
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

func _notification(what: int) -> void:
	if visible:
		match(what):
			NOTIFICATION_WM_QUIT_REQUEST:
				quitPls()
				pass
	pass
